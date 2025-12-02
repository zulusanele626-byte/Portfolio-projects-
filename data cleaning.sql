--cleaning data in SQL Q ueries

select *
from Portfolioproject.dbo.[Nashvillehousing ]


--standardize sale Date

select SaleDateConverted, CONVERT(Date,SaleDate)
from Portfolioproject.dbo.[Nashvillehousing ]

update [Nashvillehousing ]
SET SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted date;

update [Nashvillehousing ]
SET SaleDateConverted=CONVERT(Date,SaleDate)

--Populate property Address Data

select *
from Portfolioproject.dbo.[Nashvillehousing ]
--where PropertyAddress is Null
order by ParcelID


select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
from Portfolioproject.dbo. Nashvillehousing a
JOIN Portfolioproject.dbo. Nashvillehousing b
    on a.parcelID = b.ParcelID
	AND a.[uniqueID]<>b.[uniqueID]
Where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
from Portfolioproject.dbo. Nashvillehousing a
JOIN Portfolioproject.dbo. Nashvillehousing b
    on a.parcelID = b.ParcelID
	Where a.PropertyAddress is null
	AND a.[uniqueID]<>b.[uniqueID]


--Breaking Out Address Into Individual Columnns (Address, City, State)

select PropertyAddress
from Portfolioproject.dbo.[Nashvillehousing ]
--where PropertyAddress is Null
--order by ParcelID



SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)- 1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 ,LEN(propertyAddress)) as Address

FROM Portfolioproject.dbo.[Nashvillehousing ]


ALTER TABLE NashvilleHousing
Add PropertySplitAddress  Nvarchar(255);

update [Nashvillehousing ]
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)- 1)

ALTER TABLE NashvilleHousing
Add PropertySpliCity Nvarchar(255);


update [Nashvillehousing ]
SET  PropertySpliCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 ,LEN(propertyAddress))


select *
from Portfolioproject.dbo.Nashvillehousing


--chnage Y and N to YES and NO in "sold as Vacant" Field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM Portfolioproject.dbo.[Nashvillehousing ]
Group BY SoldAsVacant
Order by 2




Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant 
	   END
FROM Portfolioproject.dbo.Nashvillehousing 



Update [Nashvillehousing ]
SET SoldAsVacant =  Case When SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant 
	   END 

--Remove DUplicates


WITH RowNumCTE AS(
select*,
  ROW_NUMBER() OVER(
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY 
			          UniqueID
					  )row_num

FROM Portfolioproject.dbo.NashvilleHousing 
)
SELECT*
FROM RowNumCTE
WHERE row_num >1
--ORDER BY PropertyAddress




SELECT*
FROM Portfolioproject.dbo.[Nashvillehousing ]





--DELECT UNUSED COLUMNS 

SELECT*
FROM Portfolioproject.dbo.[Nashvillehousing ]



ALTER TABLE Portfolioproject.dbo.[Nashvillehousing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolioproject.dbo.[Nashvillehousing ]
DROP COLUMN SaleDate