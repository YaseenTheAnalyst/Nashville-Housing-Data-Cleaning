# Nashville Housing Data Cleaning Project

## Overview
This project involves cleaning and transforming data from the Nashville Housing dataset using SQL queries. The primary tasks include exploring the data, changing date formats, populating missing property addresses, breaking down address columns, standardizing 'SoldAsVacant' values, removing duplicates, and deleting unused columns.

## SQL Queries

### Exploring Data
- Retrieve all records from the `NashvilleHousing` table.

```sql
SELECT * 
FROM NashvilleHousing;
```
د

### Changing SaleDate Format
Alter the table to add a new column (SaleDateConverted) with a standardized date format.
Update the new column with converted dates.

```sql
ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);
```

### Populating Property Address Data
Populate missing property addresses by updating records based on ParcelID.

```sql
-- Populating Property Address Data
-- (code snippet for SELECT statement not shown here)

-- Update records with missing property addresses
UPDATE N1
SET PropertyAddress = ISNULL(N1.PropertyAddress, N2.PropertyAddress)
FROM NashvilleHousing N1
JOIN NashvilleHousing N2
	ON N1.ParcelID = N2.ParcelID
	AND N1.UniqueID <> N2.UniqueID
WHERE N1.PropertyAddress IS NULL;
```

### Breaking Property Address Column
Break down the PropertyAddress column into two individual columns: Address and City.

```sql
-- Breaking Property Address Column
-- (code snippet for SELECT statement not shown here)

-- Add new columns
ALTER TABLE NashvilleHousing
ADD Address NVARCHAR(255);

-- Update the new columns
UPDATE NashvilleHousing
SET Address = SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE NashvilleHousing
ADD City NVARCHAR(255);

UPDATE NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));
```
### Changing 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant Column
Standardize values in the SoldAsVacant column.

```sql
-- Changing 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant Column
-- (code snippet for SELECT statement not shown here)

-- Update the column
UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;
```

### Removing Duplicates
Remove duplicate records based on specific columns.

```sql
-- Removing Duplicates
-- (code snippet for WITH statement not shown here)

-- Delete duplicates
WITH RowNumCte AS (
    -- ...
)
DELETE 
FROM RowNumCte
WHERE row_num > 1;
```

### Deleting Unused Columns
Remove columns that are no longer needed.

```sql
-- Deleting Unused Columns
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;
```

```sql
### Checking the Result
Verify that the cleaning process was successful.
```

## Happy Cleaning!

























