### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 3df5f1ac-04e7-4d4e-bb5f-337de425ceaa
using DataFrames

# ╔═╡ 6221c383-0dac-4fcb-a118-9605fe8ecbad
using BenchmarkTools

# ╔═╡ 246b4260-d740-11eb-086b-2787ea9462c5
md"""
# Introduction to DateFrames
"""

# ╔═╡ 6f39cb6d-a82a-4877-b42e-b0506cdcefd7
md"""
## Manipulating columns of a DataFrame
### Renaming columns
Let's start with a `DataFrame` of `Bool`s that has default column names.
"""

# ╔═╡ ef39fb79-cf21-4947-9ca1-d69665eaf402
df = DataFrame(rand(Bool, 3, 4), :auto)

# ╔═╡ c0c63138-572e-475d-9f0b-a093d5255a9d
begin
	using Random
	Random.seed!(1234)
	df[:, shuffle(names(df))]
end

# ╔═╡ 6ccf3791-c3bb-469d-9b5f-48d328afc6e9
md"""
With `rename`, we create a new `DataFrame`; here we rename the column `:x1` to `:A`. (`rename` also accepts collections of `Pair`s.)
"""

# ╔═╡ 1134fb89-34b8-490a-80d7-6f3f994d4181
rename(df, :x1 => :A)

# ╔═╡ 13ada549-3a7f-4720-a8ad-c4cb4c3e0fdd
rename(df, [:x1 => :A, :x2 => :B])

# ╔═╡ 0450e841-046c-4ca8-8469-d5a3a14ca62b
md"""
With `rename!` we do an in-place transformation. This time we've applied a function to every column name (note that the function gets a column names as a string).
"""

# ╔═╡ 3ffd8352-bc1c-4c7a-9ccc-f851a0a22a81
rename!(c -> c^2, df)

# ╔═╡ 3463ff47-3f00-4163-a554-330b78e23d93
md"""
We can also change the name of a particular column without knowing the original. Here we change the name of the third column, creating a new `DataFrame`.
"""

# ╔═╡ 021f1cc9-c4f1-4c04-9306-15091318266c
rename(df, 3 => :third)

# ╔═╡ bf686232-2077-4df8-a09e-86d84dd7d0ae
md"""
If we pass a vector of names to `rename!`, we can change the names of all variables.
"""

# ╔═╡ 3e49dd82-053c-423a-a066-d3dcfe4a4911
md"""
!!! warning "Matching length"
	The length of the vector must match the number of columns.
"""

# ╔═╡ 88d3ba1e-9f72-432d-82d9-da017848beb9
rename!(df, [:a, :b, :c, :d])

# ╔═╡ 09868540-a80b-4bf8-a346-c4f3057fd31b
md"""
In all the above examples you could have used strings instead of symbols, *e.g.*
"""

# ╔═╡ 47d4803c-de67-4cb7-827e-2d84b48a9626
rename!(df, string.('a':'d'))

# ╔═╡ 8ed534ca-e02b-46f2-8f4f-f5ca5897d8ed
md"""
`rename!` allows for circular renaming of columns, *e.g.*:
"""

# ╔═╡ 3a641bbe-5619-44ec-9018-3342f92459e7
df

# ╔═╡ 3787bae4-0aef-4ebb-a17b-eb382799d61f
rename!(df, "a"=>"d", "d"=>"a")

# ╔═╡ f0e9f092-f71d-41a6-8943-7cbc4a9845cc
md"""
!!! warning "No duplicate names"
	We get an error when we try to provide duplicate names.
"""

# ╔═╡ 4d6bb5f9-e6e7-4709-b3be-0e75ef280639
rename(df, fill(:a, 4))

# ╔═╡ 85003598-fbf4-4720-b0a0-981f6c515860
md"""
Unless we pass `makeunique=true`, which allows us to handle duplicates in passed names.
"""

# ╔═╡ 5df412a6-0f3a-4748-b76f-096ba5085b61
rename(df, fill(:a, 4), makeunique=true)

# ╔═╡ 818813b3-56ed-4f9a-8327-d3d6ee49f4e6
md"""
### Reordering columns
We can reorder the `names(df)` vector as needed, creating a new `DataFrame`.
"""

# ╔═╡ bdd9492b-74d0-4bcb-b0c7-d8047049ab1a
md"""
Also `select!` can be used to achieve this in place (or `select` to perform a copy):
"""

# ╔═╡ 865f08c0-4f63-45b5-95e9-954821e4476d
df

# ╔═╡ 970265ba-3451-4a30-90b4-e5f6e97496e3
select!(df, 4:-1:1);

# ╔═╡ 772340d6-6b99-429c-8b83-5fa08e9efa4a
df

# ╔═╡ ef117cfb-5719-446f-9ce6-39373b5e8593
md"""
### Merging/adding columns
"""

# ╔═╡ d648a4c7-ffa4-432d-bb45-d8baef429aa7
df2 = DataFrame([(i, j) for i in 1:3, j in 1:4], :auto)

# ╔═╡ 81c44404-5aed-4ea1-a311-0fce994820a5
md"""
With `hcat` we can merge two `DataFrame`s. Also `[x y]` syntax is supported but only when `DataFrame`s have unique column names.
"""

# ╔═╡ d5f4dff0-2af4-4f02-97ec-a92953e05d80
hcat(df2, df2, makeunique=true)

# ╔═╡ b6f6e5ae-94e5-4e26-a39f-5d5071e7ce19
md"""
We can also use `hcat` to add a new column; a default name `:x1` will be used for this column, so `makeunique=true` is needed in our case.
"""

# ╔═╡ 5c48b0f7-5a40-4d88-beaa-94904857942f
hcat(df2, [1, 2, 3], makeunique=true)

# ╔═╡ 99692cee-5cc9-41b5-8a04-96aac4328d2d
md"""
You can also prepend a vector with `hcat`.
"""

# ╔═╡ 3463672c-9b9a-4ebf-86f7-f49f0e62e3b2
hcat([1, 2, 3], df2, makeunique=true)

# ╔═╡ a7926343-d5ff-4be7-a67a-f6cc7a13d4e1
md"""
Alternatively you could append a vector with the following syntax. This is a bit more verbose but cleaner.
"""

# ╔═╡ 16975409-ba1d-4d75-a70e-fc3da5224150
[df2 DataFrame(A=[1, 2, 3])]

# ╔═╡ 64e970ce-82a1-4d96-887d-428f8f45701d
md"""
Here we do the same but add column `:A` to the front.
"""

# ╔═╡ 33af27a4-6d54-47c5-a063-1883640647f9
[DataFrame(A=[1, 2, 3]) df2]

# ╔═╡ 2f814601-42c9-47e2-ba46-5a95809b9819
md"""
A column can also be added in the middle. Here a brute-force method is used and a new `DataFrame` is created.
"""

# ╔═╡ a95fc7e7-9eda-49e7-b724-ae2bdff851d3
@belapsed [$df2[!, 1:2] DataFrame(A=[1, 2, 3]) $df2[!, 3:4]]

# ╔═╡ 5d01bb41-371c-4c5c-ad7d-020a2e0e2c03
md"""
We could also do this with a specialized in place method `insertcols!`. Let's add `:newcol` to the data frame `df2`.
"""

# ╔═╡ 32d3b324-20c9-48ea-9759-bb91b76135d8
insertcols!(df2, 2, "newcol" => [1, 2, 3])

# ╔═╡ 524b97f3-ff47-4300-9371-f87607c4e361
md"""
If you want to insert the same column name several times `makeunique=true` is needed as usual.
"""

# ╔═╡ c8adf86c-1cd9-4bd7-bc01-1179de18ebeb
insertcols!(df2, 2, :newcol => [1, 2, 3], makeunique=true)

# ╔═╡ 3b2675a3-4416-495a-a642-56f5525dc59b
md"""
We can see how much faster it is to insert a column with `insertcols!` than with `hcat` using `@belapsed` (note that we use here a `Pair` notation as an example).
"""

# ╔═╡ 7a7747ab-8562-49e1-98b0-2006ff5530d9
@belapsed insertcols!(copy($df2), 3, :A => [1, 2, 3])

# ╔═╡ 84402cc2-c2a1-4bae-b186-5f16dbbddf1d
md"""
Let's use `insertcols!` to append a column in place (note that we dropped the index at which we insert the column).
"""

# ╔═╡ dd907896-40e6-483b-a7d4-1dd889379132
insertcols!(df2, :A => [1, 2, 3])

# ╔═╡ 89c9c452-3f87-494b-ae52-bdcc6758299b
md"""
and to in place prepend a column.
"""

# ╔═╡ 9785f907-a961-4699-9301-a89001aab630
insertcols!(df2, 1, :B => [1, 2, 3])

# ╔═╡ 82939e06-c0ea-4ef9-ada9-22179708ba4e
md"""
Note that `insertcols!` can be used to insert several columns to a data frame at once and that it performs broadcasting if needed:
"""

# ╔═╡ c99f9f15-5cf0-470c-a348-e8dbb6cd490f
df3 = DataFrame(a = [1, 2, 3])

# ╔═╡ 4521a352-eacd-4812-ab0d-26781e63c93e
insertcols!(df3, :b => "x", :c => 'a':'c', :d => Ref([1, 2, 3]))

# ╔═╡ e09c874c-6547-418d-b3ee-1cf680ef55fa
md"""
Interestingly we can emulate `hcat` mutating the data frame in-place using `insertcols!`:
"""

# ╔═╡ aaf673f9-c3cc-4f6c-a357-f2b49cfaab35
df4 = DataFrame(a=[1, 2])

# ╔═╡ 0a046f6a-4fe5-4a97-9159-c1a04c0927db
df5 = DataFrame(b=[2, 3], c=[3, 4])

# ╔═╡ 1706fe31-6974-4d7e-87c4-162bd14272e9
hcat(df4, df5)

# ╔═╡ 391cb55c-0900-4787-a597-3edec96c0a6c
df4 # df4 is not touched

# ╔═╡ 5c71fbfc-1089-46e7-8a75-1fba8b19e1bb
insertcols!(df4, pairs(eachcol(df5))...)

# ╔═╡ 75995e92-4122-48df-ae65-fcf03eca22d3
df4 # Now we have changed df4

# ╔═╡ c0a58267-6b50-4add-80da-12909ead637c
md"""
### Subsetting/removing columns
Let's create a new DataFrame `df6` and show a few ways to create DataFrames with a subset of `df6`'s columns.
"""

# ╔═╡ 778b49e9-4dac-4f4f-b7e3-e554ccd92d0f
df6 = DataFrame([(i, j) for i in 1:3, j in 1:5], :auto)

# ╔═╡ 5c99493a-fd5b-4886-9610-908f32dde382
md"""
First we could do this by index:
"""

# ╔═╡ d9f6dacd-ab8e-426f-995c-944027e01d81
df6[:, [1, 2, 4, 5]] # use ! instead of : for non-copying operation

# ╔═╡ 47c0cd98-10eb-4d24-9831-e464bb51a7b0
md"""
or by column name:
"""

# ╔═╡ 6b35ebd8-9ef1-474e-9831-69e145e558dd
df6[:, [:x1, :x4]]

# ╔═╡ 651eb493-67d7-4e8b-9df6-fd467e23483d
md"""
We can also choose to keep or exclude columns by `Bool` (we need a vector whose length is the number of columns in the original `DataFrame`).
"""

# ╔═╡ cdab5252-e3b9-48e2-bf38-2edf832c3c38
df6[:, [true, false, true, false, true]]

# ╔═╡ 677cd807-2d27-48e0-9642-6d159493c6fe
md"""
Here we create a single column `DataFrame`,
"""

# ╔═╡ 460a1df7-fa7e-4e2d-a4ef-335393b9d4d2
df6[:, [:x1]]

# ╔═╡ 166c6171-aee7-4fff-b88c-3c8011bb0667
md"""
and here we access the vector contained in column `:x1`.
"""

# ╔═╡ c84c552a-c054-4403-adf8-b4fa327e2650
df6[!, :x1] # use : instead of ! to copy

# ╔═╡ c44f1938-5c32-45a0-bb91-cb0e71d45168
df6.x1 # the same

# ╔═╡ c8da880d-d57f-432b-b6a6-128f94a7a430
md"""
!!! note "Copy vs Reference"
	`:` creates a fresh copy but `!` just creates a reference.
"""

# ╔═╡ dc0ed858-72ae-455c-bc84-38faff3cbcc9
(
	df6.x1 ==  df6[!, :x1], # have same value
	df6.x1 === df6[!, :x1], # have same reference
	df6.x1 ==  df6[:, :x1], # have same value
	df6.x1 === df6[:, :x1], # have different reference
)

# ╔═╡ f63b1015-fe92-4d15-83be-f48c140dfe02
md"""
We could grab the same vector by column number
"""

# ╔═╡ aee935e6-eab8-4541-aea0-2cf8c58765fb
df6[!, 1]

# ╔═╡ e0c93452-a42e-4046-9f4c-5cae984e92ea
md"""
Note that getting a single column returns it without copying while creating a new `DataFrame` performs a copy of the column.
"""

# ╔═╡ 0aed01ba-bb2c-4833-b666-a4af986cf325
(
	df6[!, 1] === df6[!, [1]],                                                         
)

# ╔═╡ Cell order:
# ╟─246b4260-d740-11eb-086b-2787ea9462c5
# ╠═3df5f1ac-04e7-4d4e-bb5f-337de425ceaa
# ╟─6f39cb6d-a82a-4877-b42e-b0506cdcefd7
# ╠═ef39fb79-cf21-4947-9ca1-d69665eaf402
# ╟─6ccf3791-c3bb-469d-9b5f-48d328afc6e9
# ╠═1134fb89-34b8-490a-80d7-6f3f994d4181
# ╠═13ada549-3a7f-4720-a8ad-c4cb4c3e0fdd
# ╟─0450e841-046c-4ca8-8469-d5a3a14ca62b
# ╠═3ffd8352-bc1c-4c7a-9ccc-f851a0a22a81
# ╟─3463ff47-3f00-4163-a554-330b78e23d93
# ╠═021f1cc9-c4f1-4c04-9306-15091318266c
# ╟─bf686232-2077-4df8-a09e-86d84dd7d0ae
# ╟─3e49dd82-053c-423a-a066-d3dcfe4a4911
# ╠═88d3ba1e-9f72-432d-82d9-da017848beb9
# ╟─09868540-a80b-4bf8-a346-c4f3057fd31b
# ╠═47d4803c-de67-4cb7-827e-2d84b48a9626
# ╟─8ed534ca-e02b-46f2-8f4f-f5ca5897d8ed
# ╠═3a641bbe-5619-44ec-9018-3342f92459e7
# ╠═3787bae4-0aef-4ebb-a17b-eb382799d61f
# ╟─f0e9f092-f71d-41a6-8943-7cbc4a9845cc
# ╠═4d6bb5f9-e6e7-4709-b3be-0e75ef280639
# ╟─85003598-fbf4-4720-b0a0-981f6c515860
# ╠═5df412a6-0f3a-4748-b76f-096ba5085b61
# ╟─818813b3-56ed-4f9a-8327-d3d6ee49f4e6
# ╠═c0c63138-572e-475d-9f0b-a093d5255a9d
# ╟─bdd9492b-74d0-4bcb-b0c7-d8047049ab1a
# ╠═865f08c0-4f63-45b5-95e9-954821e4476d
# ╠═970265ba-3451-4a30-90b4-e5f6e97496e3
# ╠═772340d6-6b99-429c-8b83-5fa08e9efa4a
# ╟─ef117cfb-5719-446f-9ce6-39373b5e8593
# ╠═d648a4c7-ffa4-432d-bb45-d8baef429aa7
# ╟─81c44404-5aed-4ea1-a311-0fce994820a5
# ╠═d5f4dff0-2af4-4f02-97ec-a92953e05d80
# ╟─b6f6e5ae-94e5-4e26-a39f-5d5071e7ce19
# ╠═5c48b0f7-5a40-4d88-beaa-94904857942f
# ╟─99692cee-5cc9-41b5-8a04-96aac4328d2d
# ╠═3463672c-9b9a-4ebf-86f7-f49f0e62e3b2
# ╟─a7926343-d5ff-4be7-a67a-f6cc7a13d4e1
# ╠═16975409-ba1d-4d75-a70e-fc3da5224150
# ╟─64e970ce-82a1-4d96-887d-428f8f45701d
# ╠═33af27a4-6d54-47c5-a063-1883640647f9
# ╟─2f814601-42c9-47e2-ba46-5a95809b9819
# ╠═6221c383-0dac-4fcb-a118-9605fe8ecbad
# ╠═a95fc7e7-9eda-49e7-b724-ae2bdff851d3
# ╟─5d01bb41-371c-4c5c-ad7d-020a2e0e2c03
# ╠═32d3b324-20c9-48ea-9759-bb91b76135d8
# ╟─524b97f3-ff47-4300-9371-f87607c4e361
# ╠═c8adf86c-1cd9-4bd7-bc01-1179de18ebeb
# ╟─3b2675a3-4416-495a-a642-56f5525dc59b
# ╠═7a7747ab-8562-49e1-98b0-2006ff5530d9
# ╟─84402cc2-c2a1-4bae-b186-5f16dbbddf1d
# ╠═dd907896-40e6-483b-a7d4-1dd889379132
# ╟─89c9c452-3f87-494b-ae52-bdcc6758299b
# ╠═9785f907-a961-4699-9301-a89001aab630
# ╟─82939e06-c0ea-4ef9-ada9-22179708ba4e
# ╠═c99f9f15-5cf0-470c-a348-e8dbb6cd490f
# ╠═4521a352-eacd-4812-ab0d-26781e63c93e
# ╟─e09c874c-6547-418d-b3ee-1cf680ef55fa
# ╠═aaf673f9-c3cc-4f6c-a357-f2b49cfaab35
# ╠═0a046f6a-4fe5-4a97-9159-c1a04c0927db
# ╠═1706fe31-6974-4d7e-87c4-162bd14272e9
# ╠═391cb55c-0900-4787-a597-3edec96c0a6c
# ╠═5c71fbfc-1089-46e7-8a75-1fba8b19e1bb
# ╠═75995e92-4122-48df-ae65-fcf03eca22d3
# ╟─c0a58267-6b50-4add-80da-12909ead637c
# ╠═778b49e9-4dac-4f4f-b7e3-e554ccd92d0f
# ╟─5c99493a-fd5b-4886-9610-908f32dde382
# ╠═d9f6dacd-ab8e-426f-995c-944027e01d81
# ╟─47c0cd98-10eb-4d24-9831-e464bb51a7b0
# ╠═6b35ebd8-9ef1-474e-9831-69e145e558dd
# ╟─651eb493-67d7-4e8b-9df6-fd467e23483d
# ╠═cdab5252-e3b9-48e2-bf38-2edf832c3c38
# ╟─677cd807-2d27-48e0-9642-6d159493c6fe
# ╠═460a1df7-fa7e-4e2d-a4ef-335393b9d4d2
# ╟─166c6171-aee7-4fff-b88c-3c8011bb0667
# ╠═c84c552a-c054-4403-adf8-b4fa327e2650
# ╠═c44f1938-5c32-45a0-bb91-cb0e71d45168
# ╠═c8da880d-d57f-432b-b6a6-128f94a7a430
# ╠═dc0ed858-72ae-455c-bc84-38faff3cbcc9
# ╟─f63b1015-fe92-4d15-83be-f48c140dfe02
# ╠═aee935e6-eab8-4541-aea0-2cf8c58765fb
# ╟─e0c93452-a42e-4046-9f4c-5cae984e92ea
# ╠═0aed01ba-bb2c-4833-b666-a4af986cf325
