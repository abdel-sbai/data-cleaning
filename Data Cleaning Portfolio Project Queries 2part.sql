/*

Cleaning Data in SQL Queries
*/

Select *
From PortofolioProject.dbo.Nashvillehomes

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDateconverted, CONVERT(Date,saledate)
From PortofolioProject.dbo.Nashvillehomes



ALTER TABLE Nashvillehomes
Add SaleDateConverted Date;

Update Nashvillehomes
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortofolioProject.dbo.Nashvillehomes
--Where PropertyAddress is null
order by parcelID




Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject.dbo.Nashvillehomes a
JOIN PortofolioProject.dbo.Nashvillehomes b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject.dbo.Nashvillehomes a
JOIN PortofolioProject.dbo.Nashvillehomes b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortofolioProject.dbo.Nashvillehomes
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,  LEN(PropertyAddress)) as Address

From PortofolioProject.dbo.Nashvillehomes


ALTER TABLE Nashvillehomes
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehomes
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashvillehomes
Add PropertySplitCity Nvarchar(255);

Update Nashvillehomes
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortofolioProject.dbo.Nashvillehomes





Select OwnerAddress
From PortofolioProject.dbo.Nashvillehomes


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortofolioProject.dbo.Nashvillehomes



ALTER TABLE Nashvillehomes
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehomes
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashvillehomes
Add OwnerSplitCity Nvarchar(255);

Update Nashvillehomes
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashvillehomes
Add OwnerSplitState Nvarchar(255);

Update Nashvillehomes
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortofolioProject.dbo.Nashvillehomes




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortofolioProject.dbo.Nashvillehomes
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortofolioProject.dbo.Nashvillehomes


Update Nashvillehomes
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortofolioProject.dbo.Nashvillehomes
--order by ParcelID
)
select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From PortofolioProject.dbo.Nashvillehomes




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortofolioProject.dbo.Nashvillehomes


ALTER TABLE PortofolioProject.dbo.Nashvillehomes
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


























