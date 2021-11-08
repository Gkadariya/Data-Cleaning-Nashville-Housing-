-- Data cleaning in SQL 

Select *
From MyProject..NashvilleHousing

-- Standardize Sale Date Format 
Alter Table MyProject..NashvilleHousing
Add Sale_Date Date;

update MyProject..NashvilleHousing
SET Sale_Date = Convert(date, SaleDate)

Select Sale_Date
From MyProject..NashvilleHousing

-- Populate Property Address Data
-- There are NULL in Property Address which should not be and will have to populate it
Select *
From MyProject..NashvilleHousing
 -- Where PropertyAddress is null
order by ParcelID

 -- do a self JOIN to find where the ParcelID are same but has NULL in Property Address
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress) AS Property_Address
From MyProject..NashvilleHousing a 
JOIN MyProject..NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Update the 'NashvilleHousing a' table and populate the NULL 'PropertyAddress' 
Update a 
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From MyProject..NashvilleHousing a 
JOIN MyProject..NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Break out Address into individual columns (Address, City)
select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From MyProject..NashvilleHousing
-- Add new column for street address
ALTER TABLE MyProject..NashvilleHousing
ADD Street_Address NVARCHAR(255);
-- update street address
Update MyProject..NashvilleHousing
SET Street_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

-- add city column 
ALTER TABLE MyProject..NashVilleHousing
ADD City NVARCHAR(255);

-- Update city column 
Update MyProject..NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-- Break out Owners Address into (Address, City, State)
Select
Parsename(REPLACE(OwnerAddress, ',' , '.'), 3) ,
Parsename(REPLACE(OwnerAddress, ',' , '.'), 2) ,
Parsename(REPLACE(OwnerAddress, ',' , '.'), 1) 

From MyProject..NashvilleHousing

-- Add new Owner_street_address column 
ALTER TABLE MyProject..NashvilleHousing
ADD Owner_Street_Address NVARCHAR(255);

Update MyProject..NashvilleHousing
Set Owner_Street_Address = Parsename(REPLACE(OwnerAddress, ',' , '.'), 3)

-- Add new Owner_City column
ALTER TABLE MyProject..NashvilleHousing
ADD Owner_City NVARCHAR(255);

Update MyProject..NashvilleHousing
Set Owner_City = Parsename(REPLACE(OwnerAddress, ',' , '.'), 2)

-- Add new Owner_State column 
ALTER TABLE MyProject..NashvilleHousing
ADD Owner_State NVARCHAR(255);

Update MyProject..NashvilleHousing
Set Owner_State = Parsename(REPLACE(OwnerAddress, ',' , '.'), 1)

-- Change Y and N to Yes and No in "Sold as Vacant" column 
select distinct(SoldAsVacant), Count(SoldAsVacant)
From MyProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant, 
CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant END
from MyProject..NashvilleHousing

Update MyProject..NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant END

-- Delete  Unused Columns 

select * 
from MyProject..NashvilleHousing

Alter table MyProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table MyProject..NashvilleHousing
Drop Column SaleDate