@{
    'name'='Log in to ghcr.io'
    'uses'='docker/login-action@master'
    'with'=@{
        'registry'='${{ env.REGISTRY }}'
        'username'='${{ github.actor }}'
        'password'='${{ secrets.GITHUB_TOKEN }}'
    }
    env = @{
        'REGISTRY'='ghcr.io'
    }
}
@{
    name = 'Extract Docker Metadata (for branch)'
    if   = '${{github.ref_name != ''main'' && github.ref_name != ''master'' && github.ref_name != ''latest''}}'
    id   = 'meta'
    uses = 'docker/metadata-action@master'
    with = @{
        'images'='${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}'                
    }
    env = @{
        REGISTRY = 'ghcr.io'
        IMAGE_NAME = '${{ github.repository }}'
    }
}
@{
    name = 'Extract Docker Metadata (for main)'
    if   = '${{github.ref_name == ''main'' || github.ref_name == ''master'' || github.ref_name == ''latest''}}'
    id   = 'metaMain'
    uses = 'docker/metadata-action@master'
    with = @{
        'images'='${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}'
        'flavor'='latest=true'
    }
}
@{
    name = 'Build and push Docker image (from main)'
    if   = '${{github.ref_name == ''main'' || github.ref_name == ''master'' || github.ref_name == ''latest''}}'
    uses = 'docker/build-push-action@master'
    with = @{
        'context'='.'
        'push'='true'
        'tags'='${{ steps.metaMain.outputs.tags }}'
        'labels'='${{ steps.metaMain.outputs.labels }}'
    }
}
@{
    name = 'Build and push Docker image (from branch)'
    if   = '${{github.ref_name != ''main'' && github.ref_name != ''master'' && github.ref_name != ''latest''}}'
    uses = 'docker/build-push-action@master'
    with = @{
        'context'='.'
        'push'='true'
        'tags'='${{ steps.meta.outputs.tags }}'
        'labels'='${{ steps.meta.outputs.labels }}'
    }
}