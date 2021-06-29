### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ d832eb30-d69c-11eb-0d31-055c2515794e
using DataFrames

# ╔═╡ 3f6e49d3-b354-4f40-97fb-85d23b55ccc5
md"""
# Introduction to DataFrames
"""

# ╔═╡ 8b1ce7be-008c-4f52-9ff1-ea3051a9861e
md"""
## Getting basic information about a data frame
Let's start by creating a `DataFrame` object, `x`, so that we can learn how to get information on that data frame.
"""

# ╔═╡ 5c39be46-c130-4ec4-8c6f-a799ebc6de38
x = DataFrame(A = [1, 2], B = [1.0, missing], C = ["a", "b"])

# ╔═╡ bfb3a3ce-593a-479c-8343-e7a10c42660a
md"""
The standard `size` function works to get dimensions of the `DataFrame`,
"""

# ╔═╡ 52f963f7-88f1-42cb-918a-55751e601bed
size(x), size(x, 1), size(x, 2)

# ╔═╡ a24bd70f-c2e7-48f4-998a-ac50f3d9d154
md"as well as `nrow` and `ncol` from *R*."

# ╔═╡ d749ee25-0112-4b9f-b9fd-f25bcb374f2b
nrow(x), ncol(x)

# ╔═╡ b8e5376a-0355-4d59-9894-be5749027089
md"""
`describe` gives basic summary statistics of data in your data frame (check out the help of `describe` for information on how to customize shown statistics).
"""

# ╔═╡ fa73b34d-e0b1-4af4-a3cd-0f11c714fd0c
describe(x)

# ╔═╡ fecc75f4-703f-4157-b92a-11a399ee402c
md"You can limit the columns shown by `describe` using `cols` keyword argument."

# ╔═╡ d6e057c6-10da-4465-8bfe-04c4bd18bd05
describe(x, cols=1:2)

# ╔═╡ dc97c754-7e6f-48a6-bc27-b695ee1df8ca
md"`names` will return the names of all columns as strings."

# ╔═╡ 1f2efb7f-8c9e-4b77-8ef4-e2aa7c771efa
names(x)

# ╔═╡ 14bc5c56-58f4-4620-b07d-7dc33eb71faa
md"You can also get column names with a given `eltype`:"

# ╔═╡ 5e48fd9b-bfc4-424f-b56f-ebe5ab1622c1
names(x, String)

# ╔═╡ b2deb0f0-a29c-458c-a25d-0cdd0e661cf3
md"Use `propertynames` to get a vector of `Symbol`s:"

# ╔═╡ 4a907820-be34-4128-85fb-b1592a92dc4b
propertynames(x)

# ╔═╡ cecb2ea1-4c52-4e99-bf14-a96aa24c8fc4
md"Using `eltype` on `eachcol(x)` returns element types of columns:"

# ╔═╡ 65aac350-9abe-44b3-a5c6-d284186fb2f8
eltype.(eachcol(x))

# ╔═╡ bd4ac300-f883-4098-b697-708db77dbb78
md"Here we create some large data frame:"

# ╔═╡ 60d5ab8c-7b26-4295-a371-7a03fa7a66ae
y = DataFrame(rand(1:10, 1000, 10), :auto)

# ╔═╡ 68c576f9-fb52-43b9-90ed-3d570f492cb8
md"and then we can use `first` to peek into its first few rows"

# ╔═╡ 24f69aab-4f29-4ae8-9734-1f36716fc893
first(y, 5)

# ╔═╡ 9cf9c1b8-2b60-4e95-8041-d91d25052812
md"and `last` to see its bottom rows."

# ╔═╡ 4d82ccb2-b9bf-4102-bdae-0004ff6b517d
last(y, 3)

# ╔═╡ cf0a55a6-457d-4c39-9197-53801e9b96d3
md"""
Using `first` and `last` without number of rows will return a first/last `DataFrameRow` in the data frame
"""

# ╔═╡ 789aeea6-eece-4da9-826b-219706883f3e
first(y)

# ╔═╡ 01a664db-ca44-4f4a-a840-3bf089551cb2
last(y)

# ╔═╡ cb9a15b6-26d0-45b2-940d-fa613b62d382
md"""
### Displaying large data frames
Create a wide and tall data frame:
"""

# ╔═╡ a02c8255-ba6a-48f6-8cdf-7df247772c30
df = DataFrame(rand(100, 100), :auto)

# ╔═╡ 8f15fd4f-5f3c-4ce5-8e7e-970e4d25d314
md"""
we can see that 92 of its columns were not printed. Also we get its first 10 rows. You can click `more` to show more columns or rows.
"""

# ╔═╡ 3a5d9ba0-6ff7-4d79-beb9-0cdc80f93619
md"""
### Most elementary get and set operations
Given the data frame `x` we have created earlier, here are various ways to grab one of its columns as a `Vector`.
"""

# ╔═╡ 500c8085-b324-4195-bfa9-b58dd4bd0700
x

# ╔═╡ 762e6e2e-eb4f-4c60-a0f7-0675940748e8
x.A, x[!, 1], x[!, :A] # all get the vector stored in our DataFrame without copying it

# ╔═╡ 18db91b9-bfb9-4570-bcec-900350d44951
x."A", x[!, "A"] # the same using string indexing

# ╔═╡ ba4405dc-1a3d-4dc1-8d78-8eb8f1685f45
x[:, 1] # note that this creates a copy

# ╔═╡ 4a967780-ab03-4a64-acb4-d1daeed1ddba
x[:, 1] === x[:, 1]

# ╔═╡ 624997c6-e76c-4bdf-bb3a-a72ea0b3aa7a
md"To grab one row as a `DataFrame`, we can index as follows."

# ╔═╡ 40e7c479-3403-4931-91eb-b35cd882680d
x[1:1, :]

# ╔═╡ cb58be46-db11-42f1-8ad9-13ce17983868
x[1, :] # this produces a DataFrameRow which is treated as 1-dimensional object similar to a NamedTuple

# ╔═╡ 040a5bba-5e6f-437d-ac79-68f5b40db6d5
md"""
We can grab a single cell or element with the same syntax to grab an element of an array.
"""

# ╔═╡ 22d3a58a-70f2-4a12-994a-b8b10a3e35f1
x[1, 1]

# ╔═╡ aaa802e3-ac90-4a55-9f46-033539bf6132
md"""
or a new `DataFrame` that is a subset of rows and columns.
"""

# ╔═╡ f2221831-9ec6-42a2-90a3-88b63f745f5c
x[1:2, 1:2]

# ╔═╡ 40102ddc-675f-49c5-af30-8fd75257455a
md"""
You can also use *Regex* to select columns and `Not` from [InvertedIndices.jl](https://github.com/mbauman/InvertedIndices.jl) both to select rows and columns
"""

# ╔═╡ 786fe7c8-98eb-4762-bc60-4368a704ebcc
x[Not(1), r"A"]

# ╔═╡ 68ffcdb6-4790-4096-a5aa-91d35071399e
x[!, Not(1)] # ! indicates that underlying columns are not copied

# ╔═╡ 6cf85d4f-bb1d-4579-96ef-52ed414aace8
x[:, Not(1)] # : means that the columns will get copied

# ╔═╡ d026d138-948d-49ba-99a3-c9c5643ab7f6
md"""
Assignment of a scalar to a data frame can be done in ranges using broadcasting:
"""

# ╔═╡ fa7debc7-1f9a-4e55-8f7e-3aefc5950cd8
x[1:2, 1:2] .= 1

# ╔═╡ 8f1ddeae-06fe-4873-9521-647cecfd01fd
md"""
Assignment of a vector of length equal to the number of assigned rows using broadcasting
"""

# ╔═╡ ad7f5f36-9fdf-4796-8459-8c6a591d8ef2
x[1:2, 1:2] .= DataFrame([5 6; 7 8], [:A, :B])

# ╔═╡ 247d51a4-ed6e-4a44-91b1-7c1301742c1a
md"""
**Caution**

With `df[!, :col]` and `df.col` syntax you get a direct (non copying) access to a column of a data frame. This is potentially unsafe as you can easily corrupt data in the `df` data frame if you resize, sort, etc. the column obtained in this way. Therefore such access should be used with caution.

Similarly `df[!, cols]` when `cols` is a collection of columns produces a new data frame that holds the same (not copied) columns as the source df data frame. Similarly, modifying the data frame obtained via `df[!, cols]` might cause problems with the consistency of `df`.

The `df[:, :col]` and `df[:, cols]` syntaxes always copy columns so they are safe to use (and should generally be preferred except for performance or memory critical use cases).

Here are examples of how `Cols` and `Between` can be used to select columns of a data frame.
"""

# ╔═╡ ea3fc4dd-8daf-4077-9f23-62547b3d8091
xx = DataFrame(rand(4, 5), :auto)

# ╔═╡ 9837d8a9-5f5c-4f3c-b699-216a3d8bea23
xx[:, Between(:x2, :x4)]

# ╔═╡ 3ad1efcb-68c1-4f4b-8f5f-1b022efa7d47
xx[:, Cols("x1", Between("x2", "x4"))]

# ╔═╡ 61413b25-409b-4fbd-aba7-8db673b6eead
xx[:, Cols("x1", Between(:x2, :x4))] == xx[:, Cols(:x1, Between("x2", :x4))]

# ╔═╡ 4ae63e0a-dfe5-487c-967b-50c57889d9a3
md"""
### Views
You can simply create a view of a `DataFrame` (it is more efficient than creating a materialized selection). Here are the possible return value options.
"""

# ╔═╡ cc39f38d-683d-437d-ac5e-0e7950575999
@view xx[1:2, 1]

# ╔═╡ f7c2f393-b720-4500-a3cd-70ce2fdf9d91
@view xx[1, 1]

# ╔═╡ 50a469c1-fcf8-49d2-9bdc-2b6e3f379100
@view x[1, 1:2] # a DataFrameRow, the same as for x[1, 1:2] without a view

# ╔═╡ 4fbe548a-e56b-4880-bea7-f882e27dfd46
@view xx[1:2, 1:2] # A SubDataFrame

# ╔═╡ d03c3cf3-136a-43e0-929f-b21ee7a96003
md"""
### Adding new columns to a data frame
"""

# ╔═╡ ebadfd63-85e9-4e02-89d4-04eb8384aa0b
df2 = DataFrame()

# ╔═╡ 88461431-f690-450a-89d8-195b5bc10cf5
md"Using setproperty!"

# ╔═╡ bfb05a1d-3e91-4340-8152-3cb3eaa95b6e
begin
	z = [1, 2, 3]
	df2.a = z
	df2
end

# ╔═╡ 7d617a72-723e-4ae8-b508-c904142604a2
md"Below confirms that no copy is performed."

# ╔═╡ 956ffd11-1206-45bf-847b-5828dc7607f1
df2.a === z

# ╔═╡ eac66c8f-8f17-4252-978e-7e6afa56288d
md"Using setindex!"

# ╔═╡ 9d887dec-1fe3-4175-b0e2-b7d815fbf08e
begin
	df2[!, :b] = z
	df2[:, :c] = z
	df2
end

# ╔═╡ 0e9e1746-3ce4-4c52-83a3-57af131a6c1e
df2.b === z # no copy

# ╔═╡ eef12f25-9b00-4148-af85-a094ab7675c9
df2.c === z # copy

# ╔═╡ 17e57aa8-d3bc-41a3-a68c-0e73220a8b5f
begin
	df2[!, :d] .= z
	df2[:, :e] .= z
	df2
end

# ╔═╡ d41582e7-1406-4820-91a6-4ca7784e35e6
df2.d === z, df2.e === z # both copy, so in this case `!` and `:` has the same effect

# ╔═╡ b3c4354b-a061-41b7-b303-f4160dac43cd
md"""
Note that in our data frame `df2`, columns `:a` and `:b` store the vector `z` (not a copy).
"""

# ╔═╡ c65fb1d6-b6e5-4931-9cea-e353b1292faa
df2.a === df2.b === z

# ╔═╡ de66c0a4-b8e7-4fe7-a677-98857202f538
md"""
This can lead to silent errors. For example, this code leads to a bug (note that calling `pairs` on `eachcol(df2)` creates an iterator of (column name, column) pairs):
"""

# ╔═╡ 07e41cbf-3cc9-4a4a-ac68-efb58a9d7b4e
for (n, c) in pairs(eachcol(df2))
    println("$n: ", pop!(c))
end

# ╔═╡ be3269d9-e215-4c3c-9e87-63ac56749c7e
md"""
Note that for column `:b` we printed 2 as 3 was removed from it when we used `pop!` on column `:a`.

Such mistakes sometimes happen. Because of this [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) performs consistency checks before doing an expensive operation (most notably before showing a data frame).
"""

# ╔═╡ 872d5349-bd95-4f6c-971c-3d9673f1b0d5
df2

# ╔═╡ 4b10852c-b8b8-4d95-80b0-175e017f2d71
md"We can investigate the columns to find out what happend:"

# ╔═╡ b81b74dc-6957-49f5-a835-aabae2ce4fbb
collect(pairs(eachcol(df2)))

# ╔═╡ 441f68fb-9d00-4415-b170-47391772b902
md"""
The output confirms that the data frame `df2` got corrupted.

[DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) supports a complete set of `getindex`, `getproperty`, `setindex!`, `setproperty!`, `view`, broadcasting, and broadcasting assignment operations. The details are explained here: [indexing](http://juliadata.github.io/DataFrames.jl/latest/lib/indexing/).
"""

# ╔═╡ c2ed5a2d-9fa6-4a1e-bfb8-f8fe1840c150
md"### Comparisons"

# ╔═╡ 5fac08c3-24e5-4279-a95c-37ed95cf97c2
df3 = DataFrame(rand(2,3), :auto)

# ╔═╡ 298de72a-bdae-44e8-a9a8-efb281ec9aa1
df4 = copy(df3)

# ╔═╡ cb0e5070-9ba6-459f-954c-40469d12d18f
df3 == df4 # compares column names and contents

# ╔═╡ 5b3804cd-8976-42a7-b1e4-ab1d7e8edfb1
df3 === df4 # compares reference

# ╔═╡ 8b1ff524-9d3f-4834-8145-bb914871518b
md"""
Create a minimally different data frame and use `isapprox` for comparison.
"""

# ╔═╡ 2b228639-0671-459b-9130-df8e0117d8ff
df5 = df4 .+ eps()

# ╔═╡ c951d381-1594-49d5-8ad8-d4dcb5ca8766
df4 == df5

# ╔═╡ e0756418-e31d-4bd2-97b6-493da1ae9846
isapprox(df4, df5)

# ╔═╡ 832ced76-07df-40c5-8d4f-e564768cb735
isapprox(df4, df5, atol = eps()/2)

# ╔═╡ cafa613f-814e-43b7-9702-8ef500307c20
md"`missing`s are handled as in *Julia* Base"

# ╔═╡ d7451d5f-3490-4081-8327-436988230a64
df6 = DataFrame(a=missing)

# ╔═╡ 705e44f8-fb5d-4ae5-80f3-1e0054078afe
df6 == df6

# ╔═╡ 4693449d-f7ea-4cba-85c8-19ca75052e5a
df6 === df6

# ╔═╡ e92563f5-f298-4b12-9e49-18068754e1f1
isequal(df6, df6)

# ╔═╡ Cell order:
# ╟─3f6e49d3-b354-4f40-97fb-85d23b55ccc5
# ╠═d832eb30-d69c-11eb-0d31-055c2515794e
# ╟─8b1ce7be-008c-4f52-9ff1-ea3051a9861e
# ╠═5c39be46-c130-4ec4-8c6f-a799ebc6de38
# ╟─bfb3a3ce-593a-479c-8343-e7a10c42660a
# ╠═52f963f7-88f1-42cb-918a-55751e601bed
# ╟─a24bd70f-c2e7-48f4-998a-ac50f3d9d154
# ╠═d749ee25-0112-4b9f-b9fd-f25bcb374f2b
# ╟─b8e5376a-0355-4d59-9894-be5749027089
# ╠═fa73b34d-e0b1-4af4-a3cd-0f11c714fd0c
# ╠═fecc75f4-703f-4157-b92a-11a399ee402c
# ╠═d6e057c6-10da-4465-8bfe-04c4bd18bd05
# ╟─dc97c754-7e6f-48a6-bc27-b695ee1df8ca
# ╠═1f2efb7f-8c9e-4b77-8ef4-e2aa7c771efa
# ╟─14bc5c56-58f4-4620-b07d-7dc33eb71faa
# ╠═5e48fd9b-bfc4-424f-b56f-ebe5ab1622c1
# ╟─b2deb0f0-a29c-458c-a25d-0cdd0e661cf3
# ╠═4a907820-be34-4128-85fb-b1592a92dc4b
# ╟─cecb2ea1-4c52-4e99-bf14-a96aa24c8fc4
# ╠═65aac350-9abe-44b3-a5c6-d284186fb2f8
# ╟─bd4ac300-f883-4098-b697-708db77dbb78
# ╠═60d5ab8c-7b26-4295-a371-7a03fa7a66ae
# ╠═68c576f9-fb52-43b9-90ed-3d570f492cb8
# ╠═24f69aab-4f29-4ae8-9734-1f36716fc893
# ╠═9cf9c1b8-2b60-4e95-8041-d91d25052812
# ╠═4d82ccb2-b9bf-4102-bdae-0004ff6b517d
# ╠═cf0a55a6-457d-4c39-9197-53801e9b96d3
# ╠═789aeea6-eece-4da9-826b-219706883f3e
# ╠═01a664db-ca44-4f4a-a840-3bf089551cb2
# ╟─cb9a15b6-26d0-45b2-940d-fa613b62d382
# ╠═a02c8255-ba6a-48f6-8cdf-7df247772c30
# ╟─8f15fd4f-5f3c-4ce5-8e7e-970e4d25d314
# ╟─3a5d9ba0-6ff7-4d79-beb9-0cdc80f93619
# ╠═500c8085-b324-4195-bfa9-b58dd4bd0700
# ╠═762e6e2e-eb4f-4c60-a0f7-0675940748e8
# ╠═18db91b9-bfb9-4570-bcec-900350d44951
# ╠═ba4405dc-1a3d-4dc1-8d78-8eb8f1685f45
# ╠═4a967780-ab03-4a64-acb4-d1daeed1ddba
# ╟─624997c6-e76c-4bdf-bb3a-a72ea0b3aa7a
# ╠═40e7c479-3403-4931-91eb-b35cd882680d
# ╟─cb58be46-db11-42f1-8ad9-13ce17983868
# ╟─040a5bba-5e6f-437d-ac79-68f5b40db6d5
# ╠═22d3a58a-70f2-4a12-994a-b8b10a3e35f1
# ╟─aaa802e3-ac90-4a55-9f46-033539bf6132
# ╠═f2221831-9ec6-42a2-90a3-88b63f745f5c
# ╟─40102ddc-675f-49c5-af30-8fd75257455a
# ╠═786fe7c8-98eb-4762-bc60-4368a704ebcc
# ╠═68ffcdb6-4790-4096-a5aa-91d35071399e
# ╠═6cf85d4f-bb1d-4579-96ef-52ed414aace8
# ╟─d026d138-948d-49ba-99a3-c9c5643ab7f6
# ╠═fa7debc7-1f9a-4e55-8f7e-3aefc5950cd8
# ╟─8f1ddeae-06fe-4873-9521-647cecfd01fd
# ╠═ad7f5f36-9fdf-4796-8459-8c6a591d8ef2
# ╟─247d51a4-ed6e-4a44-91b1-7c1301742c1a
# ╠═ea3fc4dd-8daf-4077-9f23-62547b3d8091
# ╠═9837d8a9-5f5c-4f3c-b699-216a3d8bea23
# ╠═3ad1efcb-68c1-4f4b-8f5f-1b022efa7d47
# ╠═61413b25-409b-4fbd-aba7-8db673b6eead
# ╟─4ae63e0a-dfe5-487c-967b-50c57889d9a3
# ╠═cc39f38d-683d-437d-ac5e-0e7950575999
# ╠═f7c2f393-b720-4500-a3cd-70ce2fdf9d91
# ╠═50a469c1-fcf8-49d2-9bdc-2b6e3f379100
# ╠═4fbe548a-e56b-4880-bea7-f882e27dfd46
# ╟─d03c3cf3-136a-43e0-929f-b21ee7a96003
# ╠═ebadfd63-85e9-4e02-89d4-04eb8384aa0b
# ╟─88461431-f690-450a-89d8-195b5bc10cf5
# ╠═bfb05a1d-3e91-4340-8152-3cb3eaa95b6e
# ╟─7d617a72-723e-4ae8-b508-c904142604a2
# ╠═956ffd11-1206-45bf-847b-5828dc7607f1
# ╟─eac66c8f-8f17-4252-978e-7e6afa56288d
# ╠═9d887dec-1fe3-4175-b0e2-b7d815fbf08e
# ╠═0e9e1746-3ce4-4c52-83a3-57af131a6c1e
# ╠═eef12f25-9b00-4148-af85-a094ab7675c9
# ╠═17e57aa8-d3bc-41a3-a68c-0e73220a8b5f
# ╠═d41582e7-1406-4820-91a6-4ca7784e35e6
# ╟─b3c4354b-a061-41b7-b303-f4160dac43cd
# ╠═c65fb1d6-b6e5-4931-9cea-e353b1292faa
# ╟─de66c0a4-b8e7-4fe7-a677-98857202f538
# ╠═07e41cbf-3cc9-4a4a-ac68-efb58a9d7b4e
# ╟─be3269d9-e215-4c3c-9e87-63ac56749c7e
# ╠═872d5349-bd95-4f6c-971c-3d9673f1b0d5
# ╠═4b10852c-b8b8-4d95-80b0-175e017f2d71
# ╠═b81b74dc-6957-49f5-a835-aabae2ce4fbb
# ╟─441f68fb-9d00-4415-b170-47391772b902
# ╟─c2ed5a2d-9fa6-4a1e-bfb8-f8fe1840c150
# ╠═5fac08c3-24e5-4279-a95c-37ed95cf97c2
# ╠═298de72a-bdae-44e8-a9a8-efb281ec9aa1
# ╠═cb0e5070-9ba6-459f-954c-40469d12d18f
# ╠═5b3804cd-8976-42a7-b1e4-ab1d7e8edfb1
# ╟─8b1ff524-9d3f-4834-8145-bb914871518b
# ╠═2b228639-0671-459b-9130-df8e0117d8ff
# ╠═c951d381-1594-49d5-8ad8-d4dcb5ca8766
# ╠═e0756418-e31d-4bd2-97b6-493da1ae9846
# ╠═832ced76-07df-40c5-8d4f-e564768cb735
# ╠═cafa613f-814e-43b7-9702-8ef500307c20
# ╠═d7451d5f-3490-4081-8327-436988230a64
# ╠═705e44f8-fb5d-4ae5-80f3-1e0054078afe
# ╠═4693449d-f7ea-4cba-85c8-19ca75052e5a
# ╠═e92563f5-f298-4b12-9e49-18068754e1f1
