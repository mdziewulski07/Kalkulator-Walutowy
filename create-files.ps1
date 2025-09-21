# create-files.ps1
$root = "C:\Users\admin\kalkulator_walutowy_git"
if (-not (Test-Path $root)) {
  Write-Error "Folder nie istnieje: $root"
  exit 1
}
Set-Location $root

$manifest = @"
App.tsx
__tests__/snapshots/AppearanceScreen.test.tsx
__tests__/snapshots/CalculatorScreen.test.tsx
__tests__/snapshots/MonetizationScreen.test.tsx
app.json
assets/adaptive-icon.png
assets/currencies.json
assets/icon.png
assets/splash.png
babel.config.js
jest.setup.ts
package.json
scripts/build-currency-list.js
scripts/data/base-translations.json
scripts/data/manual-translations.json
scripts/generate-translations.js
src/features/calculator/__tests__/useCalculator.test.ts
src/features/calculator/useCalculator.ts
src/features/rates/RatesProvider.ts
src/features/rates/RatesService.ts
src/features/rates/__tests__/RatesService.test.ts
src/i18n/i18n.ts
src/i18n/locales/aa.json
src/i18n/locales/ab.json
src/i18n/locales/ae.json
src/i18n/locales/af.json
src/i18n/locales/ak.json
src/i18n/locales/am.json
src/i18n/locales/an.json
src/i18n/locales/ar.json
src/i18n/locales/as.json
src/i18n/locales/av.json
src/i18n/locales/ay.json
src/i18n/locales/az.json
src/i18n/locales/ba.json
src/i18n/locales/be.json
src/i18n/locales/bg.json
src/i18n/locales/bh.json
src/i18n/locales/bi.json
src/i18n/locales/bm.json
src/i18n/locales/bn.json
src/i18n/locales/bo.json
src/i18n/locales/br.json
src/i18n/locales/bs.json
src/i18n/locales/ca.json
src/i18n/locales/ce.json
src/i18n/locales/ch.json
src/i18n/locales/co.json
src/i18n/locales/cr.json
src/i18n/locales/cs.json
src/i18n/locales/cu.json
src/i18n/locales/cv.json
src/i18n/locales/cy.json
src/i18n/locales/da.json
src/i18n/locales/de.json
src/i18n/locales/dv.json
src/i18n/locales/dz.json
src/i18n/locales/ee.json
src/i18n/locales/el.json
src/i18n/locales/en-GB.json
src/i18n/locales/en-US.json
src/i18n/locales/en.json
src/i18n/locales/eo.json
src/i18n/locales/es-419.json
src/i18n/locales/es.json
src/i18n/locales/et.json
src/i18n/locales/eu.json
src/i18n/locales/fa.json
src/i18n/locales/ff.json
src/i18n/locales/fi.json
src/i18n/locales/fj.json
src/i18n/locales/fo.json
src/i18n/locales/fr.json
src/i18n/locales/fy.json
src/i18n/locales/ga.json
src/i18n/locales/gd.json
src/i18n/locales/gl.json
src/i18n/locales/gn.json
src/i18n/locales/gu.json
src/i18n/locales/gv.json
src/i18n/locales/ha.json
src/i18n/locales/he.json
src/i18n/locales/hi.json
src/i18n/locales/ho.json
src/i18n/locales/hr.json
src/i18n/locales/ht.json
src/i18n/locales/hu.json
src/i18n/locales/hy.json
src/i18n/locales/hz.json
src/i18n/locales/ia.json
src/i18n/locales/id.json
src/i18n/locales/ie.json
src/i18n/locales/ig.json
src/i18n/locales/ii.json
src/i18n/locales/ik.json
src/i18n/locales/index.ts
src/i18n/locales/io.json
src/i18n/locales/is.json
src/i18n/locales/it.json
src/i18n/locales/iu.json
src/i18n/locales/ja.json
src/i18n/locales/jv.json
src/i18n/locales/ka.json
src/i18n/locales/kg.json
src/i18n/locales/ki.json
src/i18n/locales/kj.json
src/i18n/locales/kk.json
src/i18n/locales/kl.json
src/i18n/locales/km.json
src/i18n/locales/kn.json
src/i18n/locales/ko.json
src/i18n/locales/kr.json
src/i18n/locales/ks.json
src/i18n/locales/ku.json
src/i18n/locales/kv.json
src/i18n/locales/kw.json
src/i18n/locales/ky.json
src/i18n/locales/la.json
src/i18n/locales/lb.json
src/i18n/locales/lg.json
src/i18n/locales/li.json
src/i18n/locales/ln.json
src/i18n/locales/lo.json
src/i18n/locales/lt.json
src/i18n/locales/lu.json
src/i18n/locales/lv.json
src/i18n/locales/mg.json
src/i18n/locales/mh.json
src/i18n/locales/mi.json
src/i18n/locales/mk.json
src/i18n/locales/ml.json
src/i18n/locales/mn.json
src/i18n/locales/mr.json
src/i18n/locales/ms.json
src/i18n/locales/mt.json
src/i18n/locales/my.json
src/i18n/locales/na.json
src/i18n/locales/nb.json
src/i18n/locales/nd.json
src/i18n/locales/ne.json
src/i18n/locales/ng.json
src/i18n/locales/nl.json
src/i18n/locales/nn.json
src/i18n/locales/no.json
src/i18n/locales/nr.json
src/i18n/locales/nv.json
src/i18n/locales/ny.json
src/i18n/locales/oc.json
src/i18n/locales/oj.json
src/i18n/locales/om.json
src/i18n/locales/or.json
src/i18n/locales/os.json
src/i18n/locales/pa.json
src/i18n/locales/pi.json
src/i18n/locales/pl.json
src/i18n/locales/ps.json
src/i18n/locales/pt-BR.json
src/i18n/locales/pt-PT.json
src/i18n/locales/pt.json
src/i18n/locales/qu.json
src/i18n/locales/rm.json
src/i18n/locales/rn.json
src/i18n/locales/ro.json
src/i18n/locales/ru.json
src/i18n/locales/rw.json
src/i18n/locales/sa.json
src/i18n/locales/sc.json
src/i18n/locales/sd.json
src/i18n/locales/se.json
src/i18n/locales/sg.json
src/i18n/locales/si.json
src/i18n/locales/sk.json
src/i18n/locales/sl.json
src/i18n/locales/sm.json
src/i18n/locales/sn.json
src/i18n/locales/so.json
src/i18n/locales/sq.json
src/i18n/locales/sr.json
src/i18n/locales/ss.json
src/i18n/locales/st.json
src/i18n/locales/su.json
src/i18n/locales/sv.json
src/i18n/locales/sw.json
src/i18n/locales/ta.json
src/i18n/locales/te.json
src/i18n/locales/tg.json
src/i18n/locales/th.json
src/i18n/locales/ti.json
src/i18n/locales/tk.json
src/i18n/locales/tl.json
src/i18n/locales/tn.json
src/i18n/locales/to.json
src/i18n/locales/tr.json
src/i18n/locales/ts.json
src/i18n/locales/tt.json
src/i18n/locales/tw.json
src/i18n/locales/ty.json
src/i18n/locales/ug.json
src/i18n/locales/uk.json
src/i18n/locales/ur.json
src/i18n/locales/uz.json
src/i18n/locales/ve.json
src/i18n/locales/vi.json
src/i18n/locales/vo.json
src/i18n/locales/wa.json
src/i18n/locales/wo.json
src/i18n/locales/xh.json
src/i18n/locales/yi.json
src/i18n/locales/yo.json
src/i18n/locales/za.json
src/i18n/locales/zh-Hans.json
src/i18n/locales/zh-Hant.json
src/i18n/locales/zh.json
src/i18n/locales/zu.json
src/monetization/__tests__/purchases.test.ts
src/monetization/ads.tsx
src/monetization/consent.tsx
src/monetization/purchases.tsx
src/screens/AppNavigator.tsx
src/screens/CalculatorScreen.tsx
src/screens/RatesChart.tsx
src/screens/RatesChartScreen.tsx
src/screens/__tests__/RatesChart.test.tsx
src/settings/AppearanceScreen.tsx
src/settings/MonetizationScreen.tsx
src/settings/SettingsHomeScreen.tsx
src/store/appStore.ts
src/store/index.ts
src/theme/ThemeProvider.tsx
src/theme/index.ts
src/utils/currency.ts
tsconfig.json
"@

$files = $manifest -split "`r?`n" | Where-Object { $_.Trim().Length -gt 0 }

foreach ($rel in $files) {
  $path = Join-Path $root $rel
  $dir  = Split-Path $path
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  if (-not (Test-Path $path)) {
    $ext = [System.IO.Path]::GetExtension($path).ToLowerInvariant()
    switch ($ext) {
      ".ts"  { $content = "// TODO: wklej treść wygenerowaną przez Codex dla: $rel`n" }
      ".tsx" { $content = "// TODO: wklej treść wygenerowaną przez Codex dla: $rel`n" }
      ".js"  { $content = "// TODO: wklej treść wygenerowaną przez Codex dla: $rel`n" }
      ".json"{ $content = "{}" }
      ".png" { $content = $null } # utworzymy pusty plik binarny
      default{ $content = "" }
    }
    if ($ext -eq ".png") {
      New-Item -ItemType File -Path $path -Force | Out-Null
    } else {
      Set-Content -Path $path -Value $content -Encoding UTF8 -NoNewline
    }
    Write-Host ("Utworzono: " + $rel)
  } else {
    Write-Host ("Istnieje, pomijam: " + $rel)
  }
}

Write-Host "`nGotowe. Teraz podmień pliki .png prawdziwymi grafikami i wklej właściwą treść do plików .ts/.tsx/.js/.json." -ForegroundColor Green
