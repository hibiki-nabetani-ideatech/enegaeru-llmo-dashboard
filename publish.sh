#!/usr/bin/env bash
# ============================================================
# GitHub Pages 公開スクリプト
#   このファイルがあるフォルダで  bash publish.sh  を実行してください。
#   事前に gh auth login（または GitHub Desktop でサインイン）が必要です。
# ============================================================
set -euo pipefail

OWNER="hibiki-nabetani-ideatech"
REPO="enegaeru-llmo-dashboard"

# public / private の選択。
#   GitHub Pages は private リポジトリだと有料プラン（Pro/Team/Enterprise）が必要です。
#   既存の ideatech-llmo-dashboard と揃えるなら public。
#   public でも <meta robots=noindex> と robots.txt で検索エンジンからは除外されます
#   （＝URLを知らない人には見つからないが、URLを知れば誰でも見られる状態）。
VISIBILITY="public"

cd "$(dirname "$0")"

echo "▶ リポジトリを初期化しています..."
git init -b main 2>/dev/null || true
git add -A
git commit -m "国際航業（エネがえる）LLMO Dashboard: Monitoring / Strategy 初版（2026-07 計測）" || true

if command -v gh >/dev/null 2>&1; then
  echo "▶ GitHub にリポジトリを作成して push します（$VISIBILITY）..."
  gh repo create "$OWNER/$REPO" --"$VISIBILITY" --source=. --remote=origin --push || {
    echo "  （リポジトリが既にある場合は push だけ試します）"
    git remote add origin "https://github.com/$OWNER/$REPO.git" 2>/dev/null || true
    git push -u origin main
  }

  echo "▶ GitHub Pages を有効化します（main / root）..."
  gh api -X POST "repos/$OWNER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" 2>/dev/null \
    || gh api -X PUT "repos/$OWNER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" 2>/dev/null \
    || echo "  ※ 自動有効化に失敗しました。Settings → Pages で Branch=main / Folder=/(root) を選んでください。"
else
  echo "gh CLI が見つかりません。GitHub 上で $OWNER/$REPO を作成したうえで、以下を実行してください:"
  echo "  git remote add origin https://github.com/$OWNER/$REPO.git"
  echo "  git push -u origin main"
  echo "その後 Settings → Pages で Branch=main / Folder=/(root) を選択してください。"
fi

cat <<MSG

────────────────────────────────────────────────
公開URL（Pages 有効化から1〜2分で反映されます）

  https://$OWNER.github.io/$REPO/
  https://$OWNER.github.io/$REPO/monitoring
  https://$OWNER.github.io/$REPO/strategy
────────────────────────────────────────────────
MSG
