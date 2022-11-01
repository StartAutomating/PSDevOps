#requires -Module PSSVG

$assetsPath = Join-Path $PSScriptRoot Assets

if (-not (Test-path $assetsPath)) {
    $null = New-Item -ItemType Directory -Path $assetsPath -Force
}
=<svg> -ViewBox 200, 100 -OutputPath (Join-Path $assetsPath "PSDevOps.svg") -Content @(
    $commonParameters = @{
        Fill        = '#4488FF'
        Stroke      = 'black'
        StrokeWidth = '0.05'
    }

    =<svg.symbol> -Id psChevron -Content @(
        =<svg.polygon> -Points (@(
            "40,20"
            "45,20"
            "60,50"
            "35,80"
            "32.5,80"
            "55,50"
        ) -join ' ')
    ) -ViewBox 100, 100

    =<svg.use> -Href '#psChevron' -X -32.5% -Y 30% @commonParameters -Height 40% -Opacity .9  -Content @(
        =<svg.animate> -RepeatDur 'indefinite' -Values '.9;.8;.9' -AttributeName opacity -Dur 2s
    )

    =<svg.text> -X 50% -Y 50% -Fontsize 24 "PSDevOps" -DominantBaseline middle -TextAnchor 'middle' -Fill '#4488ff' -FontFamily sans-serif 
    =<svg.text> -X 62.5% -Y 48%  -DominantBaseline middle -TextAnchor 'middle' -Fill '#4488ff' -FontFamily sans-serif -Opacity .5 -FontWeight 'lighter' @(        
        =<svg.tspan> -Content "∞" -Fontsize 12
        =<svg.animate> -RepeatDur 'indefinite' -Values '.5;.4;.5' -AttributeName opacity -Dur 2s
    )
)
