
-- EXPLORING DATA

SELECT * 
FROM NashvilleHousing;


-- CHANGING SaleDate FORMAT

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

-- POPULATE PROPERTY ADRESS DATA

SELECT *
FROM NashvilleHousing
--(WHERE PropertyAddress IS NULL)
ORDER BY ParcelID;


SELECT N1.ParcelID, N1.PropertyAddress, N2.ParcelID, N2.PropertyAddress, ISNULL(N1.PropertyAddress, N2.PropertyAddress)
FROM NashvilleHousing N1
JOIN NashvilleHousing N2
	ON N1.ParcelID = N2.ParcelID
	AND N1.UniqueID <> N2.UniqueID
WHERE N1.PropertyAddress IS NULL ;

UPDATE N1
SET PropertyAddress = ISNULL(N1.PropertyAddress, N2.PropertyAddress)
FROM NashvilleHousing N1
JOIN NashvilleHousing N2
	ON N1.ParcelID = N2.ParcelID
	AND N1.UniqueID <> N2.UniqueID
WHERE N1.PropertyAddress IS NULL ;



-- BREAKING PROPERTY ADDRESS COLUMN INTO TWO INDIVIDUAL COLUMNS (ADDRESS, CITY)

SELECT PropertyAddress
FROM NashvilleHousing;


SELECT 
SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM NashvilleHousing;




ALTER TABLE NashvilleHousing
ADD Address NVARCHAR(255);

UPDATE NashvilleHousing
SET Address = SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE NashvilleHousing
ADD City NVARCHAR(255);

UPDATE NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));


-- LET'S USE ANOTHER WAY TO BREAK OWNER ADDRESS COLUMN INTO (ADDRESS, CITY, STATE)

SELECT OwnerAddress
FROM NashvilleHousing;


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
FROM NashvilleHousing;



ALTER TABLE NashvilleHousing
ADD OwnerNewAdress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerNewAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);




ALTER TABLE NashvilleHousing
ADD OwnerCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);




ALTER TABLE NashvilleHousing
ADD OwnerState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);





-- CHANGING 'Y' AND 'N' TO 'YES' AND 'NO' IN SOLD AS VACANT COLUMN


SELECT DISTINCT(SoldAsVacant) ,COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;



SELECT SoldAsVacant 
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;



-- REMOVING DUPLICATES

WITH RowNumCte AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,	
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM NashvilleHousing
)
DELETE 
FROM RowNumCte
WHERE row_num >1



-- DELETING UNUSED COLUMNS


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


-- CHECKING THAT EVERYTHING IS FINE

SELECT * 
FROM NashvilleHousing
