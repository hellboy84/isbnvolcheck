# 必要なパッケージを読み込み
library(readr)
library(dplyr)

# データを読み込む
df <- read_csv("isbnvolcheck.csv", locale = locale(encoding = "UTF-8"))

# 空白とNAを「巻次」の一つのカテゴリーとして扱うために空白をNAに置き換える
df$`巻次`[df$`巻次` == ""] <- NA
# ISBNが空白（""）や欠損値（NA）の行を除外する
df_clean <- df %>%
  filter(!is.na(`ISBN`) & `ISBN` != "")

# ISBNごとに巻次に異なるデータがあるレコードを抽出
# n_distinctの数値列を作成
result <- df_clean %>%
  group_by(`ISBN`) %>%
  mutate(distinct_vol_count = n_distinct(`巻次`, na.rm = FALSE)) %>%
  filter(distinct_vol_count > 1)

# ファイル出力
write.csv(result, "isbncheck_done.csv", row.names = FALSE)
