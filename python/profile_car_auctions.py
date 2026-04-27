import pandas as pd
from pathlib import Path

DATA_PATH = Path("../car_prices_cleaned_1000_rows.csv")
OUT_PATH = Path("../docs/data_profile.md")

df = pd.read_csv(DATA_PATH)

summary = {
    "rows": len(df),
    "columns": len(df.columns),
    "missing_values": int(df.isna().sum().sum()),
    "duplicate_rows": int(df.duplicated().sum()),
}

numeric_summary = df.describe(include="number").T

with OUT_PATH.open("w", encoding="utf-8") as f:
    f.write("# Data Profile\n\n")
    f.write("## Summary\n\n")
    for key, value in summary.items():
        f.write(f"- **{key.replace('_', ' ').title()}:** {value}\n")

    f.write("\n## Numeric Summary\n\n")
    f.write(numeric_summary.to_markdown())
