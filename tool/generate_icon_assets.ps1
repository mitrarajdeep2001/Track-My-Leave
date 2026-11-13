# Draws the app icon and splash artwork (beach umbrella + sun on teal).
# Run from the project root:
#   powershell -ExecutionPolicy Bypass -File tool\generate_icon_assets.ps1
# Then regenerate platform files:
#   dart run flutter_launcher_icons
#   dart run flutter_native_splash:create

Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$iconDir = Join-Path $root 'assets\icon'
$splashDir = Join-Path $root 'assets\splash'
New-Item -ItemType Directory -Force $iconDir, $splashDir | Out-Null

$tealLight = [System.Drawing.ColorTranslator]::FromHtml('#14B8A6')
$tealDark = [System.Drawing.ColorTranslator]::FromHtml('#0F766E')
$sunColor = [System.Drawing.ColorTranslator]::FromHtml('#FBBF24')
$white = [System.Drawing.Color]::White

function New-Canvas([int]$size) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)
    return @($bmp, $g)
}

function Save-Canvas($bmp, $g, [string]$path) {
    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "wrote $path"
}

# Teal diagonal gradient. $cornerFrac > 0 gives a rounded square.
function Fill-Background($g, [int]$size, [double]$cornerFrac) {
    $rect = New-Object System.Drawing.RectangleF 0, 0, $size, $size
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $tealLight, $tealDark, ([single]45)
    if ($cornerFrac -le 0) {
        $g.FillRectangle($brush, $rect)
        return
    }
    $d = [single](2 * $size * $cornerFrac)
    $s = [single]$size
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc([single]0, [single]0, $d, $d, [single]180, [single]90)
    $p.AddArc($s - $d, [single]0, $d, $d, [single]270, [single]90)
    $p.AddArc($s - $d, $s - $d, $d, $d, [single]0, [single]90)
    $p.AddArc([single]0, $s - $d, $d, $d, [single]90, [single]90)
    $p.CloseFigure()
    $g.FillPath($brush, $p)
}

# Geometry is designed on a 1024 canvas, where at k = 1 everything fits inside
# a circle of radius 313 around (cx, cy), which is the adaptive-icon safe zone.
function Draw-Umbrella($g, [double]$cx, [double]$cy, [double]$k, $canopy, $pole, $sun) {
    $R = 200 * $k     # canopy radius
    $L = 250 * $k     # pole length below the canopy
    $hr = 46 * $k     # hook radius
    $t = 34 * $k      # pole thickness
    $ccx = $cx
    $ccy = $cy - 48 * $k   # middle of the canopy's bottom edge

    # Sun, partly tucked behind the canopy.
    $sr = 55 * $k
    $sb = New-Object System.Drawing.SolidBrush $sun
    $g.FillEllipse($sb, [single]($cx + 165 * $k - $sr), [single]($cy - 198 * $k - $sr), [single](2 * $sr), [single](2 * $sr))

    # Pole with a hook at the bottom.
    $pen = New-Object System.Drawing.Pen $pole, ([single]$t)
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $hook = New-Object System.Drawing.Drawing2D.GraphicsPath
    $hook.AddLine([single]$ccx, [single]$ccy, [single]$ccx, [single]($ccy + $L))
    $hook.AddArc([single]($ccx - 2 * $hr), [single]($ccy + $L - $hr), [single](2 * $hr), [single](2 * $hr), [single]0, [single]180)
    $g.DrawPath($pen, $hook)

    # Canopy: half circle with a scalloped bottom edge.
    $c = New-Object System.Drawing.Drawing2D.GraphicsPath
    $c.AddArc([single]($ccx - $R), [single]($ccy - $R), [single](2 * $R), [single](2 * $R), [single]180, [single]180)
    $n = 4
    $w = 2 * $R / $n
    $h = $w * 0.55
    for ($i = $n - 1; $i -ge 0; $i--) {
        $x = $ccx - $R + $i * $w
        $c.AddArc([single]$x, [single]($ccy - $h / 2), [single]$w, [single]$h, [single]0, [single]-180)
    }
    $c.CloseFigure()
    $g.FillPath((New-Object System.Drawing.SolidBrush $canopy), $c)
}

# 1. Legacy launcher icon (Android 7.x and below): rounded teal square.
$bmp, $g = New-Canvas 1024
Fill-Background $g 1024 0.22
Draw-Umbrella $g 512 512 1.15 $white $white $sunColor
Save-Canvas $bmp $g (Join-Path $iconDir 'icon.png')

# 2. Adaptive icon background: full-bleed gradient (the launcher applies the mask).
$bmp, $g = New-Canvas 1024
Fill-Background $g 1024 0
Save-Canvas $bmp $g (Join-Path $iconDir 'icon_background.png')

# 3. Adaptive icon foreground: transparent, artwork kept inside the safe zone.
$bmp, $g = New-Canvas 1024
Draw-Umbrella $g 512 512 1.0 $white $white $sunColor
Save-Canvas $bmp $g (Join-Path $iconDir 'icon_foreground.png')

# 4. Monochrome layer for Android 13+ themed icons (only the alpha is used).
$bmp, $g = New-Canvas 1024
Draw-Umbrella $g 512 512 1.0 $white $white $white
Save-Canvas $bmp $g (Join-Path $iconDir 'icon_monochrome.png')

# 5. Splash artwork: 1152 canvas, artwork inside the 768 px circle Android 12 shows.
$bmp, $g = New-Canvas 1152
Draw-Umbrella $g 576 576 1.1 $white $white $sunColor
Save-Canvas $bmp $g (Join-Path $splashDir 'splash.png')
