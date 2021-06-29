### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 1951842e-d681-11eb-3103-9903f4e5c377
using DataFrames, Random

# ╔═╡ 93532926-c437-472d-91e1-1189d3ff068f
md"""
# Introduction to DataFrames
Let's get started by loading the DataFrames package.
"""

# ╔═╡ 37cec3d2-7439-4250-b270-8e6b21d5ceb5
md"""
## Constructors and conversion
### Constructors
In this section, you'll see many ways to create a DataFrame using the DataFrame() constructor.

First, we could create an empty DataFrame,
"""

# ╔═╡ 2837278a-1ede-41da-a168-888c8324b0a9
DataFrame()

# ╔═╡ cb635feb-cf71-4f5c-8368-d31a231b27cc
md"Or we could call the constructor using keyword arguments to add columns to the DataFrame."

# ╔═╡ 5c451d74-7657-4f9f-bcdc-3b72f621d6ee
DataFrame(A=1:3, B=rand(3), C=randstring.([3,3,3]), fixed=1)

# ╔═╡ 4c74cf61-b6b7-4244-b333-ef2d19e7396a
md"""
Note in column `:fixed` that scalars get automatically broadcasted.

We can create a `DataFrame` from a dictionary, in which case keys from the dictionary will be sorted to create the `DataFrame` columns.
"""

# ╔═╡ 5129fdb8-3e47-4e00-8744-0b3fac94e12f
begin
	x = Dict("A" => [1, 2], "B" => [true, false], "C" => ['a', 'b'], "fixed" => Ref([1, 1]))
	DataFrame(x)
end

# ╔═╡ 47f61b3a-ca19-46d5-9de3-9a37c45b4fe4
md"""
This time we used `Ref` to protect a vector from being treated as a column and forcing broadcasting it into every row of `:fixed` column (note that the `[1,1]` vector is aliased in each row).

Rather than explicitly creating a dictionary first, as above, we could pass `DataFrame` arguments with the syntax of dictionary key-value pairs.

Note that in this case, we use `Symbol`s to denote the column names and arguments are not sorted. For example, `:A`, the symbol, produces `A`, the name of the first column here:
"""

# ╔═╡ a4fb5825-dda7-426a-8dc1-016146a995f5
DataFrame(:A => [1, 2], :B => [true, false], :C => ['a', 'b'])

# ╔═╡ 52acc14f-b47a-4963-bc52-5692380d764c
md"""
Although, in general, using `Symbol`s rather than strings to denote column names is preferred (as it is faster) `DataFrames.jl` accepts passing strings as column names, so this also works:
"""

# ╔═╡ 60fe728c-5aba-45e1-9299-9b5843e17809
DataFrame("A" => [1, 2], "B" => [true, false], "C" => ['a', 'b'])

# ╔═╡ 2143bdce-7bee-4f09-aa74-105bfebc7c8d
md"""
You can also pass a vector of pairs, which is useful if it is constructed programatically:
"""

# ╔═╡ 380185dc-c831-493b-8def-28222ab849fa
DataFrame([:A => [1, 2], :B => [true, false], :C => ['a', 'b'], :fixed => "const"])

# ╔═╡ a5f6d2a9-b029-4caa-87d5-8f4162901c0f
md"""
Here we create a `DataFrame` from a vector of vectors, and each vector becomes a column.
"""

# ╔═╡ 3d060750-b1e2-46da-bd5d-32d4236e24b7
DataFrame([rand(3) for i in 1:3], :auto)

# ╔═╡ 55e609eb-4cc1-42a0-a563-1dce5f087a14
DataFrame([rand(3) for i in 1:3], [:x1, :x2, :x3])

# ╔═╡ 861a1f2c-9bd9-4f0e-84c9-3102f8cb84e4
DataFrame([rand(3) for i in 1:3], ["x1", "x2", "x3"])

# ╔═╡ a9ebf86e-f2dd-4b81-ae04-ae31bd005993
md"""
As you can see you either pass a vector of column names as a second argument or `:auto` in which case column names are generated automatically.

In particular it is not allowed to pass a vector of scalars to `DataFrame` constructor.
"""

# ╔═╡ 83d02909-96a6-4f8b-9634-e72e947f1ec4
DataFrame([1, 2, 3])

# ╔═╡ 374f8b00-811d-4c9a-a78b-1335984f475d
md"""
Instead use a transposed vector if you have a vector of single values (in this way you effectively pass a two dimensional array to the constructor which is supported the same way as in vector of vectors case).
"""

# ╔═╡ 1b4ba527-906a-4f9c-8bab-4d5f422f47dd
DataFrame(permutedims([1, 2, 3]), :auto)

# ╔═╡ f80bdc59-3e02-487f-9dc1-2767f987f0ce
md"""
You can also pass a vector of `NamedTuple`s to construct a `DataFrame`:
"""

# ╔═╡ 85a6029a-e25c-425e-9f1e-f501eb0469c7
begin
	v = [(a=1, b=2), (a=3, b=4)]
	DataFrame(v)
end

# ╔═╡ 9f866736-24e0-4bbe-96fa-18f4905927b6
md"""
Alternatively you can pass a `NamedTuple` of vectors:
"""

# ╔═╡ 5b45e9d9-3b85-414c-9498-7a4127c6d4bb
begin
	nt = (a=1:3, b=11:13)
	DataFrame(nt)
end

# ╔═╡ a63791ab-b5ad-48ae-9099-efb015e7abd4
md"""
Here we create a `DataFrame` from a matrix,
"""

# ╔═╡ 82d9ecb5-d027-430f-b6d8-3e145b9c8100
DataFrame(rand(3,4), :auto)

# ╔═╡ fe82ff22-8a78-4f91-8ec5-6f3412ef2f37
md"""
and here we do the same but also pass column names.
"""

# ╔═╡ 21065e1e-39a8-472d-a37c-a3b21f83c1b2
DataFrame(rand(3, 4), Symbol.('a':'d'))

# ╔═╡ 87b650bc-26f9-478b-8d48-369a8542b659
md"or"

# ╔═╡ d5221ac4-e931-41c4-bcef-e51b1c65fe84
DataFrame(rand(3, 4), string.('a':'d'))

# ╔═╡ 92225773-f414-462e-88ec-4674918c0efe
md"""
This is how you can create a `DataFrame` with no rows, but with predefined columns and their types:
"""

# ╔═╡ ea6c59e5-d33b-4c30-821e-5fcc7a37ff54
DataFrame(A=Int[], B=Float64[], C=String[])

# ╔═╡ 18ae9d00-0bbc-4940-b055-87fbaf282e6b
md"""
Finally, we can create a `DataFrame` by copying an existing `DataFrame`.

Note that copy also copies the vectors.
"""

# ╔═╡ 37849664-3131-4772-b5ad-e63f05e56c5a
begin
	x1 = DataFrame(a=1:2, b='a':'b')
	y1 = copy(x1)
	(x1 === y1), isequal(x1, y1), (x1.a == y1.a), (x1.a === y1.a)
end

# ╔═╡ 730f54e5-f9c9-422f-a166-644b4d13e00e
md"Calling `DataFrame` on a `DataFrame` object works like copy."

# ╔═╡ 29279fee-e24c-4b2c-8a7c-dcedcafae48b
begin
	x2 = DataFrame(a=1:2, b='a':'b')
	y2 = DataFrame(x2)
	(x2 === y2), isequal(x2, y2), (x2.a == y2.a), (x2.a === y2.a)
end

# ╔═╡ 562946ba-19e3-49e3-aa1a-a0cd60d95703
md"""
You can avoid copying of columns of a `DataFrame` (if it is possible) by passing `copycols=false` keyword argument:
"""

# ╔═╡ 71dccb0b-0100-46bb-9570-a6c2fa2821f0
begin
	x3 = DataFrame(a=1:2, b='a':'b')
	y3 = DataFrame(x3, copycols=false)
	(x3 === y3), isequal(x3, y3), (x3.a == y3.a), (x3.a === y3.a)
end

# ╔═╡ a2e29a79-1d38-472a-8039-6ba88a26ece5
md"The same rule applies to other constructors."

# ╔═╡ cc6269a4-e238-4613-83e5-a79294e474f4
begin
	a = [1, 2, 3]
	df1 = DataFrame(a=a)
	df2 = DataFrame(a=a, copycols=false)
	df1.a === a, df2.a === a
end

# ╔═╡ 524045f2-fa18-4b82-bcc2-205d8bccfdc3
md"You can create a similar uninitialized `DataFrame` based on an original one:"

# ╔═╡ 3b31b35b-0830-440a-ac89-3c4603b4d7ea
x4 = DataFrame(a=1, b=1.0)

# ╔═╡ 6e66185f-e952-4447-a790-638a389df1af
similar(x4)

# ╔═╡ b6f69ec0-c1e9-4acc-ab6a-7dba1d704649
md"""
The number of rows in a new `DataFrame` can be passed as a second argument.
"""

# ╔═╡ 30294e7a-1ec6-4799-a084-b3d5adfb9ab8
similar(x4, 0)

# ╔═╡ 50cc6c34-e361-42fe-ba8a-3442d5d1872e
similar(x4, 2)

# ╔═╡ 0f5311d1-c305-4429-a97e-668f7fc58439
md"""
You can also create a new `DataFrame` from `SubDataFrame` or `DataFrameRow` (discussed in detail later in the tutorial; in particular although `DataFrameRow` is considered a 1-dimensional object similar to a `NamedTuple` it gets converted to a 1-row `DataFrame` for convinience)
"""

# ╔═╡ 927ba7f8-eaed-44f3-a3b0-e599312fa422
sdf = view(x4, [1, 1], :)

# ╔═╡ e68dcae5-2435-4881-8270-99b7efd0716e
typeof(sdf)

# ╔═╡ dd6f9831-23b3-414a-9058-ebf69e541c1d
DataFrame(sdf)

# ╔═╡ 1a1dc93e-f66a-46d7-b263-deac4f340957
dfr = x4[1, :]

# ╔═╡ 040db247-7970-4895-9259-582383116596
DataFrame(dfr)

# ╔═╡ 068be037-9c22-4a07-86bd-8020dcb0e359
md"""
### Conversion to a matrix
Let's start by creating a `DataFrame` with two rows and two columns.
"""

# ╔═╡ 2726b20a-7b41-4b3c-995e-8d0cf10e62ea
x5 = DataFrame(x=1:2, y=["A", "B"])

# ╔═╡ 8ed40bcc-b88c-423c-8b22-f5b7262ccd13
md"We can create a matrix by passing this `DataFrame` to `Matrix` or `Array`."

# ╔═╡ ea44d6bb-5104-4933-8b45-daae36cde01f
Matrix(x5)

# ╔═╡ a94695e6-92d2-4ce9-8caa-f8c9d4d63cfa
Array(x5)

# ╔═╡ d74a0ff5-4d03-488e-a7d6-abfc2008747e
md"This would work even if the `DataFrame` had some `missing`s:"

# ╔═╡ f4c907a9-ac44-4e90-9cb9-1b2354d5f7ae
x6 = DataFrame(x=1:2, y=[missing,"B"])

# ╔═╡ 9c985438-c3d9-4453-bfa9-08c77b62bd39
Matrix(x6)

# ╔═╡ 43fbe5b1-e473-4d40-a7f5-4f9e12e036c1
md"""
In the two previous matrix examples, *Julia* created matrices with elements of type Any. We can see more clearly that the type of matrix is inferred when we pass, for example, a `DataFrame` of integers to `Matrix`, creating a 2D `Array` of `Int64`s:
"""

# ╔═╡ 6fdecc94-09fd-48c5-877a-4848d91fba02
x7 = DataFrame(x=1:2, y=3:4)

# ╔═╡ 9004ce5b-02a2-4f94-80e0-507d336f9c9c
Matrix(x7)

# ╔═╡ c9526c17-59fa-4170-96ae-16406abf1d30
md"""
In this next example, *Julia* correctly identifies that `Union` is needed to express the type of the resulting `Matrix` (which contains `missing`s).
"""

# ╔═╡ 6de12914-7f36-442a-be14-e53e345c4377
x8 = DataFrame(x=1:2, y=[missing, 4])

# ╔═╡ 70f78a27-1143-407b-a546-8c5cb07f0259
Matrix(x8)

# ╔═╡ f21d119f-8a28-424d-9c82-753a82ac5e22
md"Note that we can't force a conversion of missing values to `Int`s!"

# ╔═╡ 58d27170-6cfb-4fdc-84af-c8d6653eae30
Matrix{Int}(x8)

# ╔═╡ d653fc70-8a09-4d3f-b6a9-d57c898e1bd7
md"""
### Conversion to NamedTuple related tabular structures
First define some data frame:
"""

# ╔═╡ 406109c8-7ea5-43cc-aa47-4beb3f068855
x9 = DataFrame(x=1:2, y=["A", "B"])

# ╔═╡ d22a5439-98fc-493b-afcc-089ae3a9a784
md"Now we convert a `DataFrame` into a `NamedTuple` of vectors."

# ╔═╡ 5c70ea1d-a63f-4a50-8b72-07f1c2283573
ct = Tables.columntable(x9)

# ╔═╡ a0dffa25-45a8-4a98-b2d0-b4bd0a856fb7
md"Next we convert it into a vector of `NamedTuple`s."

# ╔═╡ 53460ad7-b3a1-4bc7-985c-c50e297fb642
rt = Tables.rowtable(x9)

# ╔═╡ f37efd88-77d3-40b7-bb96-2b65fb52faa8
md"""
We can perform the conversions back to a `DataFrame` using a standard constructor call:
"""

# ╔═╡ 81a41c44-7699-4d32-8ab4-0d89e42dca1a
DataFrame(ct)

# ╔═╡ 8a79d48f-660a-412d-9f62-0a500e59bc1b
md"""
### Iterating data frame by rows or columns
Sometimes it is useful to create a wrapper around a `DataFrame` that produces its rows or columns.

For iterating columns you can use the `eachcol` function.
"""

# ╔═╡ 12907d3f-9263-445b-9d13-05180eb17c42
ec = eachcol(x9)

# ╔═╡ 40a8d649-0ce9-4860-bfca-3efaed58120b
md"""
`DataFrameColumns` object behaves as a vector (note though it is not `AbstractVector`),
"""

# ╔═╡ 46836cc5-1a0a-447e-bde1-c8aab8b69eb5
ec isa AbstractVector

# ╔═╡ c8341727-3211-4e06-a7b6-71902f90fa5b
ec[1]

# ╔═╡ 21a3c5a4-97f3-43ea-b8b2-f0f1ba05d2c3
md"but you can also index into it using column names:"

# ╔═╡ 936c11f3-f764-4fe8-a053-d21af616ae8d
ec["x"]

# ╔═╡ b7009aff-c88c-4222-ade7-d60a9dbf6026
md"""
Similarly `eachrow` creates a `DataFrameRows` object that is a vector of its rows.
"""

# ╔═╡ d4b4f2c1-f9a5-473f-bbb1-a88d385dfd0e
er = eachrow(x9)

# ╔═╡ 464c2c07-2874-406d-8931-e11026dfbdc7
md"`DataFrameRows` is an `AbstractVector`."

# ╔═╡ 3b0dda28-ca4f-4018-b417-3d8afdad828e
er isa AbstractVector

# ╔═╡ 42638173-1d4c-46ad-a63f-ecef01f06444
er[end]

# ╔═╡ 57ed47a8-e6ca-4181-bce5-580fea7f004b
md"""
Note that both `DataFrame` and also `DataFrameColumns` and `DataFrameRows` objects are not type stable (they do not know the types of their columns). This is useful to avoid compilation cost if you have very wide data frames with heterogenous column types.

However, often (especially if a data frame is narrow) it is useful to create a lazy iterator that produces `NamedTuple`s for each row of the `DataFrame`. Its key benefit is that it is type stable (so it is useful when you want to perform some operations in a fast way on a small subset of columns of a `DataFrame` - this strategy is often used internally by [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) package):
"""

# ╔═╡ cece3781-9aa3-42e8-8e92-61ee740eed69
nti = Tables.namedtupleiterator(x9)

# ╔═╡ 47e711fb-3a50-43f0-902a-e43d812d3f57
for row in enumerate(nti)
    @show row
end

# ╔═╡ 923b4239-bad7-4afa-9a88-8f60cbef4995
md"""
Similarly to the previous options you can easily convert `NamedTupleIterator` back to a `DataFrame`.
"""

# ╔═╡ 256133d6-2798-4ca0-bf64-eab6a890bcb5
DataFrame(nti)

# ╔═╡ 44ce13dc-06d6-4e86-9c88-ca195b59c94c
md"""
### Handling of duplicate column names
We can pass the `makeunique` keyword argument to allow passing duplicate names (they get deduplicated).
"""

# ╔═╡ da45e288-f481-4cc8-b4e8-dd9c529b1e2f
df = DataFrame(:a=>1, :a=>2, :a_1=>3; makeunique=true)

# ╔═╡ 0664b8e9-a0dc-4a5e-9750-f992e6ff4cae
DataFrame(:a=>1, :a=>2, :a_1=>3)

# ╔═╡ 81e5b92f-b1b9-4db5-a64c-3894f3f1a6fe
md"""
Observe that currently `nothing` is not printed when displaying a `DataFrame` in Jupyter Notebook, but is printed in Pluto:
"""

# ╔═╡ d366e93d-8da5-4fac-b75c-e625254be199
df5 = DataFrame(x=[1, nothing], y=[nothing, "a"], z=[missing, "c"])

# ╔═╡ 85499fd7-724c-4f27-944c-17ced242aabe
md"""
Finally you can use `empty` and `empty!` functions to remove all rows from a data frame:
"""

# ╔═╡ 7d22b516-69c8-45dd-b32c-5e383975b444
empty(df5)

# ╔═╡ b5f382f1-9f56-4861-a10d-0e0f8b51e74f
df5

# ╔═╡ b534db7e-6bf5-49c6-8070-37b7a6a8aa59
empty!(df5)

# ╔═╡ 095cf14f-f6b7-4475-89e1-b26b562f059f
df5

# ╔═╡ 3dc84230-d21d-4e3f-b671-20bad8437584
md"""
### Conversion from vector of dictionaries to DataFrame
"""

# ╔═╡ 7b9c82af-109d-45ec-bf34-ab3e6905c632
begin
	d1 = [
		Dict("qty"=>200, "price"=>12.34),
		Dict("qty"=>400, "price"=>12.37),
		Dict("qty"=>700, "price"=>12.43),
		Dict("qty"=>900, "price"=>12.54),
	]
	DataFrame(d1)
end

# ╔═╡ a8bdfc82-1c09-43ca-9c5a-a61fa5d53146
begin
	d2 = [
		Dict("qty"=>200, "price"=>12.34),
		Dict("qty"=>400, "price"=>12.37),
		Dict("qty"=>700, "price"=>12.43),
		Dict("qty"=>900, "price"=>12.54),
	]
	DataFrame([(; zip(Symbol.(keys(d)), values(d))...) for d in d2])
end

# ╔═╡ 388d3a64-9e60-457d-b619-49ef68cddb41
begin
	d3 = [
		Dict(:qty=>200, :price=>12.34),
		Dict(:qty=>400, :price=>12.37),
		Dict(:qty=>700, :price=>12.43),
		Dict(:qty=>900, :price=>12.54),
	]
	DataFrame(d3)
end

# ╔═╡ Cell order:
# ╟─93532926-c437-472d-91e1-1189d3ff068f
# ╠═1951842e-d681-11eb-3103-9903f4e5c377
# ╟─37cec3d2-7439-4250-b270-8e6b21d5ceb5
# ╠═2837278a-1ede-41da-a168-888c8324b0a9
# ╟─cb635feb-cf71-4f5c-8368-d31a231b27cc
# ╠═5c451d74-7657-4f9f-bcdc-3b72f621d6ee
# ╟─4c74cf61-b6b7-4244-b333-ef2d19e7396a
# ╠═5129fdb8-3e47-4e00-8744-0b3fac94e12f
# ╟─47f61b3a-ca19-46d5-9de3-9a37c45b4fe4
# ╠═a4fb5825-dda7-426a-8dc1-016146a995f5
# ╟─52acc14f-b47a-4963-bc52-5692380d764c
# ╠═60fe728c-5aba-45e1-9299-9b5843e17809
# ╟─2143bdce-7bee-4f09-aa74-105bfebc7c8d
# ╠═380185dc-c831-493b-8def-28222ab849fa
# ╟─a5f6d2a9-b029-4caa-87d5-8f4162901c0f
# ╠═3d060750-b1e2-46da-bd5d-32d4236e24b7
# ╠═55e609eb-4cc1-42a0-a563-1dce5f087a14
# ╠═861a1f2c-9bd9-4f0e-84c9-3102f8cb84e4
# ╟─a9ebf86e-f2dd-4b81-ae04-ae31bd005993
# ╠═83d02909-96a6-4f8b-9634-e72e947f1ec4
# ╟─374f8b00-811d-4c9a-a78b-1335984f475d
# ╠═1b4ba527-906a-4f9c-8bab-4d5f422f47dd
# ╟─f80bdc59-3e02-487f-9dc1-2767f987f0ce
# ╠═85a6029a-e25c-425e-9f1e-f501eb0469c7
# ╟─9f866736-24e0-4bbe-96fa-18f4905927b6
# ╠═5b45e9d9-3b85-414c-9498-7a4127c6d4bb
# ╟─a63791ab-b5ad-48ae-9099-efb015e7abd4
# ╠═82d9ecb5-d027-430f-b6d8-3e145b9c8100
# ╟─fe82ff22-8a78-4f91-8ec5-6f3412ef2f37
# ╠═21065e1e-39a8-472d-a37c-a3b21f83c1b2
# ╟─87b650bc-26f9-478b-8d48-369a8542b659
# ╠═d5221ac4-e931-41c4-bcef-e51b1c65fe84
# ╟─92225773-f414-462e-88ec-4674918c0efe
# ╠═ea6c59e5-d33b-4c30-821e-5fcc7a37ff54
# ╟─18ae9d00-0bbc-4940-b055-87fbaf282e6b
# ╠═37849664-3131-4772-b5ad-e63f05e56c5a
# ╟─730f54e5-f9c9-422f-a166-644b4d13e00e
# ╠═29279fee-e24c-4b2c-8a7c-dcedcafae48b
# ╟─562946ba-19e3-49e3-aa1a-a0cd60d95703
# ╠═71dccb0b-0100-46bb-9570-a6c2fa2821f0
# ╠═a2e29a79-1d38-472a-8039-6ba88a26ece5
# ╠═cc6269a4-e238-4613-83e5-a79294e474f4
# ╟─524045f2-fa18-4b82-bcc2-205d8bccfdc3
# ╠═3b31b35b-0830-440a-ac89-3c4603b4d7ea
# ╠═6e66185f-e952-4447-a790-638a389df1af
# ╟─b6f69ec0-c1e9-4acc-ab6a-7dba1d704649
# ╠═30294e7a-1ec6-4799-a084-b3d5adfb9ab8
# ╠═50cc6c34-e361-42fe-ba8a-3442d5d1872e
# ╟─0f5311d1-c305-4429-a97e-668f7fc58439
# ╠═927ba7f8-eaed-44f3-a3b0-e599312fa422
# ╠═e68dcae5-2435-4881-8270-99b7efd0716e
# ╠═dd6f9831-23b3-414a-9058-ebf69e541c1d
# ╠═1a1dc93e-f66a-46d7-b263-deac4f340957
# ╠═040db247-7970-4895-9259-582383116596
# ╟─068be037-9c22-4a07-86bd-8020dcb0e359
# ╠═2726b20a-7b41-4b3c-995e-8d0cf10e62ea
# ╟─8ed40bcc-b88c-423c-8b22-f5b7262ccd13
# ╠═ea44d6bb-5104-4933-8b45-daae36cde01f
# ╠═a94695e6-92d2-4ce9-8caa-f8c9d4d63cfa
# ╟─d74a0ff5-4d03-488e-a7d6-abfc2008747e
# ╠═f4c907a9-ac44-4e90-9cb9-1b2354d5f7ae
# ╠═9c985438-c3d9-4453-bfa9-08c77b62bd39
# ╟─43fbe5b1-e473-4d40-a7f5-4f9e12e036c1
# ╠═6fdecc94-09fd-48c5-877a-4848d91fba02
# ╠═9004ce5b-02a2-4f94-80e0-507d336f9c9c
# ╟─c9526c17-59fa-4170-96ae-16406abf1d30
# ╠═6de12914-7f36-442a-be14-e53e345c4377
# ╠═70f78a27-1143-407b-a546-8c5cb07f0259
# ╟─f21d119f-8a28-424d-9c82-753a82ac5e22
# ╠═58d27170-6cfb-4fdc-84af-c8d6653eae30
# ╟─d653fc70-8a09-4d3f-b6a9-d57c898e1bd7
# ╠═406109c8-7ea5-43cc-aa47-4beb3f068855
# ╟─d22a5439-98fc-493b-afcc-089ae3a9a784
# ╠═5c70ea1d-a63f-4a50-8b72-07f1c2283573
# ╟─a0dffa25-45a8-4a98-b2d0-b4bd0a856fb7
# ╠═53460ad7-b3a1-4bc7-985c-c50e297fb642
# ╟─f37efd88-77d3-40b7-bb96-2b65fb52faa8
# ╠═81a41c44-7699-4d32-8ab4-0d89e42dca1a
# ╟─8a79d48f-660a-412d-9f62-0a500e59bc1b
# ╠═12907d3f-9263-445b-9d13-05180eb17c42
# ╟─40a8d649-0ce9-4860-bfca-3efaed58120b
# ╟─46836cc5-1a0a-447e-bde1-c8aab8b69eb5
# ╠═c8341727-3211-4e06-a7b6-71902f90fa5b
# ╟─21a3c5a4-97f3-43ea-b8b2-f0f1ba05d2c3
# ╠═936c11f3-f764-4fe8-a053-d21af616ae8d
# ╟─b7009aff-c88c-4222-ade7-d60a9dbf6026
# ╠═d4b4f2c1-f9a5-473f-bbb1-a88d385dfd0e
# ╟─464c2c07-2874-406d-8931-e11026dfbdc7
# ╠═3b0dda28-ca4f-4018-b417-3d8afdad828e
# ╠═42638173-1d4c-46ad-a63f-ecef01f06444
# ╟─57ed47a8-e6ca-4181-bce5-580fea7f004b
# ╠═cece3781-9aa3-42e8-8e92-61ee740eed69
# ╠═47e711fb-3a50-43f0-902a-e43d812d3f57
# ╟─923b4239-bad7-4afa-9a88-8f60cbef4995
# ╠═256133d6-2798-4ca0-bf64-eab6a890bcb5
# ╟─44ce13dc-06d6-4e86-9c88-ca195b59c94c
# ╠═da45e288-f481-4cc8-b4e8-dd9c529b1e2f
# ╠═0664b8e9-a0dc-4a5e-9750-f992e6ff4cae
# ╟─81e5b92f-b1b9-4db5-a64c-3894f3f1a6fe
# ╠═d366e93d-8da5-4fac-b75c-e625254be199
# ╟─85499fd7-724c-4f27-944c-17ced242aabe
# ╠═7d22b516-69c8-45dd-b32c-5e383975b444
# ╠═b5f382f1-9f56-4861-a10d-0e0f8b51e74f
# ╠═b534db7e-6bf5-49c6-8070-37b7a6a8aa59
# ╠═095cf14f-f6b7-4475-89e1-b26b562f059f
# ╠═3dc84230-d21d-4e3f-b671-20bad8437584
# ╠═7b9c82af-109d-45ec-bf34-ab3e6905c632
# ╠═a8bdfc82-1c09-43ca-9c5a-a61fa5d53146
# ╠═388d3a64-9e60-457d-b619-49ef68cddb41
