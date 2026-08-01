# 国際航業（エネがえる）LLMO ダッシュボード

GitHub Pages 公開ダッシュボード。

- ルート: https://hibiki-nabetani-ideatech.github.io/enegaeru-llmo-dashboard/
- Monitoring: https://hibiki-nabetani-ideatech.github.io/enegaeru-llmo-dashboard/monitoring
- Strategy: https://hibiki-nabetani-ideatech.github.io/enegaeru-llmo-dashboard/strategy
- 公開範囲: `<meta robots="noindex">` と `robots.txt` で検索エンジンから除外（URLを知る人のみ）
- 計測: Ahrefs Brand Radar 2026-07-30 取得

## 公開手順

```bash
bash publish.sh
```

`gh auth login` 済みであれば、リポジトリ作成 → push → Pages 有効化まで自動で走ります。
`gh` が無い場合は実行すべきコマンドを表示するので、手動で実行してください。

> **public / private**: `publish.sh` の `VISIBILITY` で切り替えます。既定は `public`。
> GitHub Pages を private リポジトリで使うには有料プラン（Pro/Team/Enterprise）が必要です。
> public でも noindex ＋ robots.txt で検索には出ませんが、URLを知れば誰でも閲覧できます。

## ファイル構成

```
index.html            Monitoring / Strategy へのランディング
monitoring/index.html Monitoring ダッシュボード（自動生成）
strategy/index.html   Strategy ダッシュボード（自動生成）
robots.txt            検索エンジン除外
publish.sh            GitHub Pages 公開スクリプト
_pipeline/            再生成用スクリプトとデータ（クライアント生データは .gitignore 済み）
```

## 再生成（毎月の更新）

`_pipeline` は `idea-llmo-dashboard` スキルの reference_implementation と同じ構成です。
案件固有の値は `_pipeline/config.py` に集約されています。

```bash
cd _pipeline

# 0) Ahrefs Brand Radar の CSV（UTF-16）を UTF-8 TSV にして data/ へ
iconv -f UTF-16 -t UTF-8 '【エネがえる-国際興業】指名.csv' > data/指名.tsv
#    …非指名 / サイテーション / ペルソナ1〜3 も同様

# 1) config.py の MONTH_LABEL / MONTH_SHORT / SURVEY_DATE を今月に更新

# 2) 基礎診断を更新する場合はサブエージェントで再診断 → data/diag.json

# 3) データ整形
python3 parse_monitoring.py     # → data_monitoring.json
python3 parse_personas.py       # → personas_data.json

# 4) 実績所感・概況を今月の内容に書き直す
#    build_monitoring.py の「▼▼▼ COPY ▼▼▼」〜「▲▲▲ COPY ここまで ▲▲▲」

# 5) ビルド
python3 build_monitoring.py     # → ../monitoring/index.html
python3 build_strategy.py       # → ../strategy/index.html

# 6) 検証（jsdom）
node verify_monitoring.js ../monitoring/index.html   # ※Chart.js のスタブが必要
node verify_strategy.js   ../strategy/index.html
```

詳細は `_pipeline/README.md` と `idea-llmo-dashboard` スキルの `references/` を参照。

### 参考ファイル

- `_pipeline/data/research.md` — エネがえるの一次情報リサーチ（出典URL付き）※gitignore
- `_pipeline/data/diag.json` — ①基礎診断 20項目のスコアと理由
- `_pipeline/data/rubric.json` — ①-1 評点定義（全案件共通）
- `_pipeline/p1〜p3_analysis.json` — ペルソナ別の推薦基準・4象限・総括
- `_pipeline/content_personas.py` — ペルソナ別の執筆コンテンツ

## 未反映の箱（データ取得後に埋める）

| 箇所 | 何待ちか | 必要なもの |
|---|---|---|
| Monitoring ★前月との差分 | 次回スナップショット | 2026年8月分の計測（初回のため比較対象なし） |
| Monitoring ②-1 流入指標 (SS) | GA4 / Search Console 権限 | GA4「閲覧者」以上、GSC「制限付き」以上 |
| Monitoring ②-2 コンバージョン (CV) | GA4 権限 | 併せてフォームに「当社を最初に知ったきっかけ（AI検索・対話型AI）」設問の追加を推奨 |
| Monitoring ★7月実績所感 ②の項 | 同上 | — |
| Strategy ④-1 実施施策 / 施策結果 | 施策の実施 | リリースURL・調査数値 |
| Strategy ④-2 IDEAコンサルティング | 定例の実施 | 定例メモ |

## 注意

- 運営会社は **国際航業株式会社（Kokusai Kogyo Co., Ltd.）** です。「国際興業」ではありません
  （元データのファイル名・親フォルダ名は依頼時の表記のままになっています）。
- `_pipeline` 直下に 0 バイトのファイルがいくつか残っています（旧構成の残骸）。
  `.gitignore` 済みなので公開には影響しませんが、手元で削除して構いません。
