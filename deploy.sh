#!/usr/bin/env bash
#
# ============================================================================
#  SK Smartomation — deploy the production build to an S3 static website
# ============================================================================
#  Run this on YOUR machine (not this session).
#
#  Before running, fill in the two variables below, then:
#     chmod +x deploy.sh
#     ./deploy.sh
# ============================================================================

set -euo pipefail

# ---- EDIT THESE TWO LINES -------------------------------------------------
BUCKET_NAME="sk-smartomation-site"   # must be globally unique across all of AWS
REGION="ap-south-1"                  # Mumbai — closest to Bengaluru/Salem
# ----------------------------------------------------------------------------

# Works whether the site files (index.html, css/, js/, content/, assets/) are
# in a sibling "build" folder, or extracted straight into this same folder.
if [ -f "../build/index.html" ]; then
  BUILD_DIR="../build"
elif [ -f "./index.html" ]; then
  BUILD_DIR="."
else
  echo "Can't find index.html — either put the site files in a sibling"
  echo "'build' folder, or extract them into this same folder, then re-run."
  exit 1
fi
echo "Using site files from: $BUILD_DIR"

# When the site files sit in this same folder as the script, don't let the
# deploy tooling itself get uploaded to the bucket.
SYNC_EXCLUDES=(--exclude "deploy.sh" --exclude "bucket-policy.json" --exclude "DEPLOY.md")

echo "== 1. Creating bucket: $BUCKET_NAME in $REGION =="
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "   Bucket already exists — skipping creation."
else
  if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION"
  else
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" \
      --create-bucket-configuration LocationConstraint="$REGION"
  fi
fi

echo "== 2. Allowing public access on the bucket =="
aws s3api put-public-access-block --bucket "$BUCKET_NAME" \
  --public-access-block-configuration \
  BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false

echo "== 3. Applying public-read bucket policy =="
sed "s/__BUCKET_NAME__/$BUCKET_NAME/g" bucket-policy.json > /tmp/sk-bucket-policy.json
aws s3api put-bucket-policy --bucket "$BUCKET_NAME" --policy file:///tmp/sk-bucket-policy.json

echo "== 4. Enabling static website hosting =="
aws s3api put-bucket-website --bucket "$BUCKET_NAME" --website-configuration '{
  "IndexDocument": {"Suffix": "index.html"},
  "ErrorDocument": {"Key": "index.html"}
}'

echo "== 5. Uploading the site (this can take a few minutes — there's video in it) =="
aws s3 sync "$BUILD_DIR" "s3://$BUCKET_NAME" --delete "${SYNC_EXCLUDES[@]}"

echo "== 6. Setting long-lived cache headers on versioned assets =="
aws s3 cp "$BUILD_DIR/css" "s3://$BUCKET_NAME/css" --recursive \
  --cache-control "public, max-age=31536000, immutable" --metadata-directive REPLACE
aws s3 cp "$BUILD_DIR/js" "s3://$BUCKET_NAME/js" --recursive \
  --cache-control "public, max-age=31536000, immutable" --metadata-directive REPLACE
aws s3 cp "$BUILD_DIR/content" "s3://$BUCKET_NAME/content" --recursive \
  --cache-control "public, max-age=31536000, immutable" --metadata-directive REPLACE

echo "== 7. Making sure index.html itself is never stale =="
aws s3 cp "$BUILD_DIR/index.html" "s3://$BUCKET_NAME/index.html" \
  --cache-control "no-cache" --metadata-directive REPLACE

echo ""
echo "Done. Your site is live at:"
echo "  http://$BUCKET_NAME.s3-website.$REGION.amazonaws.com"
echo ""
echo "(That's plain HTTP. For HTTPS and a custom domain, see the CloudFront"
echo "section at the bottom of DEPLOY.md.)"
