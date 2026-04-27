# Power BI Dashboard Export Checklist

Use this checklist to add recruiter-visible dashboard evidence to the GitHub README.

## Goal

GitHub visitors should be able to understand dashboard quality without downloading the Power BI file.

## Recommended Files to Add

Create an `images/` folder and export these PNG files from Power BI:

```text
images/executive_overview.png
images/seller_vehicle_analysis.png
images/data_model.png
```

## Export Steps in Power BI Desktop

1. Open the `.pbix` file.
2. Go to **Page 1: Executive Overview**.
3. Use **File → Export → Export to PDF**, or take a clean screenshot.
4. Save the image as `images/executive_overview.png`.
5. Go to **Page 2: Seller and Vehicle Analysis**.
6. Save the image as `images/seller_vehicle_analysis.png`.
7. Open the model view if useful and save `images/data_model.png`.

## Screenshot Quality Rules

- Use full-screen or near-full-screen Power BI Desktop.
- Hide unnecessary panes before capture.
- Make sure KPI cards are readable.
- Avoid cropped chart titles.
- Use PNG rather than JPEG for text clarity.
- Keep each image under roughly 1 MB if practical.

## README Snippet After Images Are Added

Add this near the top of `README.md` after the project summary:

```markdown
## Dashboard Preview

### Executive Overview
![Executive Overview](images/executive_overview.png)

### Seller and Vehicle Analysis
![Seller and Vehicle Analysis](images/seller_vehicle_analysis.png)
```

## Why This Matters

Recruiters usually scan a portfolio quickly. A visible dashboard preview proves Power BI skill immediately and reduces the need for them to download local files.
