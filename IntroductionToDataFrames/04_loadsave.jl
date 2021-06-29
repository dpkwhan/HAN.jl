### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 6317efa8-b8bf-4561-a8dc-0ac4df4325a3
using DataFrames

# ╔═╡ 7e776de3-3657-4640-b532-85a977a5dfd1
using CSV

# ╔═╡ 9e656cb6-9020-47c8-8159-2137eaa8dbab
using Serialization

# ╔═╡ fd4ced3d-13ce-471b-90c5-a4cea8205e25
using JDF

# ╔═╡ 7fdc4211-c5bf-4724-824d-2a23261dc415
using JLSO

# ╔═╡ 01f8938b-42d7-4d7f-bf21-011d92dcd925
using JSONTables

# ╔═╡ 61118ff0-d6f3-11eb-0d9e-95ff393d5f10
md"""
# Introduction to DateFrames
"""

# ╔═╡ ce4b20ac-cecd-4c7e-aed2-d6e6d14bf30e
md"""
## Load and save DataFrames
We do not cover all features of the packages. Please refer to their documentation to learn them.

Here we'll load [CSV.jl](https://github.com/JuliaData/CSV.jl) to read and write CSV files and [Arrow.jl](https://github.com/JuliaData/Arrow.jl), [JLSO.jl](https://github.com/invenia/JLSO.jl), and serialization, which allow us to work with a binary format and [JSONTables.jl](https://github.com/JuliaData/JSONTables.jl） for JSON interaction. Finally we consider a custom [JDF.jl](https://github.com/xiaodaigh/JDF.jl) format.
"""

# ╔═╡ 5b851fe2-9b91-4ace-a54e-809842620f66
md"Let's create a simple `DataFrame` for testing purposes,"

# ╔═╡ ee7c8535-7d5f-41de-af1b-fcb8c5920bb9
df = DataFrame(
	A=[true, false, true], 
	B=[1, 2, missing],
	C=[missing, "b", "c"], 
	D=['a', missing, 'c']
)

# ╔═╡ 56f07a9f-f5ee-4976-a23c-7a7375f8cca6
md"and use `eltype` to look at the columnwise types."

# ╔═╡ 993c4916-f634-4233-ace1-187fef770e80
eltype.(eachcol(df))

# ╔═╡ dc5a54d6-8246-451d-95cb-59072a2bc96d
md"""
### CSV.jl
Let's use CSV to save `df` to disk; make sure `df.csv` does not conflict with some file in your working directory.
"""

# ╔═╡ 697e5b51-e47e-49c0-92a0-b2fee46e118a
CSV.write("df.csv", df)

# ╔═╡ 5b28bf9d-15e1-4a21-81e8-e2d743aef64f
md"Now we can see how it was saved by reading `df.csv`."

# ╔═╡ da2fbdd7-7361-46a5-88cd-223e652fc2b4
read("df.csv", String)

# ╔═╡ db43c2aa-32e0-46b7-9e33-dd9d695018ba
md"We can also load it back."

# ╔═╡ ad1e7dab-45f0-4c64-b752-2409a5cc7adc
df2 = CSV.read("df.csv", DataFrame)

# ╔═╡ 7421f110-635e-423a-8462-c2d607906b08
md"""
Note that when loading in a `DataFrame` from a CSV the column type for column `:D` has changed!
"""

# ╔═╡ 9c6603b4-4b36-4627-9617-759a8f5ebbff
eltype.(eachcol(df2))

# ╔═╡ 0e127352-ac5d-40ab-b5e7-333e6ca44fcf
md"""
### Serialization, JDF.jl, and JLSO.jl
#### Serialization
Now we use serialization to save `df`.

There are two ways to perform serialization. The first way is to use the `Serialization.serialize` as below:

!!! warning
	In general, this process will not work if the reading and writing are done by different versions of *Julia*, or an instance of *Julia* with a different system image.
"""

# ╔═╡ 712b962e-5f25-43c8-8192-fa4467a7e05b
open("df.bin", "w") do io
    serialize(io, df)
end

# ╔═╡ 23e69b3d-cfd5-4c7f-8121-64681ad920db
md"""
Now we load back the saved file to `df3` variable. Again `df3` is identical to `df`. However, please beware that if you session does not have [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) loaded, then it may not recognise the content as `DataFrame`.
"""

# ╔═╡ 4ec593f6-fb39-46a8-b4a4-0ab0c1bdf9b9
df3 = open(deserialize, "df.bin")

# ╔═╡ 4c629c00-67cf-4644-b082-4c1ed28d1569
eltype.(eachcol(df3))

# ╔═╡ 56a3eb41-99b2-43b8-9699-9043f5f2cb3a
md"""
#### JDF.jl
[JDF.jl](https://github.com/xiaodaigh/JDF.jl) is a relatively new package designed to serialize `DataFrame`s. You can save a `DataFrame` with the `savejdf` function.
"""

# ╔═╡ 1db03d96-43cd-4350-9374-8118339abb0f
JDF.save("df.jdf", df);

# ╔═╡ 06a26ea2-d237-4cf3-b06e-93660e69d8fe
md"To load the saved JDF file, one can use the `loadjdf` function."

# ╔═╡ 016cf4c9-e5d2-4543-9f5c-fa65a93a3358
df4 = JDF.load("df.jdf") |> DataFrame

# ╔═╡ 76659148-7a00-491c-808e-5293819e64e3
isequal(df4, df)

# ╔═╡ 803cffb8-d162-432f-8ead-1586d9e9f244
md"""
JDF.jl offers the ability to load only certain columns from disk to help with working with large files.
"""

# ╔═╡ 2718b0b9-d4eb-447e-8d8c-a3be4b71fce1
# set up a JDFFile which is a on disk representation of `df` backed by JDF.jl
df_ondisk = jdf"df.jdf"

# ╔═╡ fb89971a-a93b-4312-81d3-f61582e960c9
md"We can see all the names of `df` without loading it into memory."

# ╔═╡ 7373c4b5-7e88-42ba-97e4-ba0f7186bc2d
names(df_ondisk)

# ╔═╡ 5238f479-13e1-4e9b-abbe-23deea9aa014
md"The below is an example of how to load only columns `:A` and `:D`."

# ╔═╡ 663ece90-ad74-4303-91f4-5ca4b28be99c
df5 = JDF.load(df_ondisk; cols=["A", "D"]) |> DataFrame

# ╔═╡ 8506e3b5-6c74-45c6-a3cd-91bc9df23840
md"""
#### JDF.jl vs others
For more details about design assumptions and limitations of JDF.jl check out [JDF.jl](https://github.com/xiaodaigh/JDF.jl).

#### JLSO.jl
Another way to perform serialization is by using the [JLSO.jl](https://github.com/invenia/JLSO.jl) library:
"""

# ╔═╡ ecb2db1a-80a8-41e8-957b-58ffc0a6a4cf
JLSO.save("df.jlso", :data => df)

# ╔═╡ ee90ba64-1425-4174-9844-dd971b3128f6
md"Now we can laod back the file to `df6`"

# ╔═╡ 8ee28388-5495-4355-a5fd-25464defc4bb
df6 = JLSO.load("df.jlso")[:data]

# ╔═╡ b10119aa-f27d-4b2e-af5b-d67f33f3c2e1
eltype.(eachcol(df6))

# ╔═╡ 6be7d7b1-6dcc-4bf8-bcbc-0b294d8e8a7e
md"""
#### JSONTables.jl
Often you might need to read and write data stored in JSON format. [JSONTables.jl](https://github.com/JuliaData/JSONTables.jl) provides a way to process them in row-oriented or column-oriented layout. We present both options below.
"""

# ╔═╡ ea8185a1-2bf2-4d44-b8c2-354f4c13be80
begin
	open(io -> arraytable(io, df), "df1.json", "w")
	open(io -> objecttable(io, df), "df2.json", "w")
end;

# ╔═╡ 1f94401d-2e47-4fcc-8732-914553ac3230
read("df1.json", String)

# ╔═╡ f83ef707-4068-4656-94da-1d22ca4c2726
read("df2.json", String)

# ╔═╡ f78e359a-8dd7-4c55-82ec-e2a76323dc0d
df7 = open(jsontable, "df1.json") |> DataFrame

# ╔═╡ 1e4daaee-9c0f-4723-885d-9cc5338933a8
eltype.(eachcol(df7))

# ╔═╡ fa037c89-2d83-492d-bf91-f99c1b066074
df8 = open(jsontable, "df2.json") |> DataFrame

# ╔═╡ 6175481b-f692-41de-9c9e-0d1e6f0709a1
eltype.(eachcol(df8))

# ╔═╡ Cell order:
# ╠═61118ff0-d6f3-11eb-0d9e-95ff393d5f10
# ╠═6317efa8-b8bf-4561-a8dc-0ac4df4325a3
# ╟─ce4b20ac-cecd-4c7e-aed2-d6e6d14bf30e
# ╟─5b851fe2-9b91-4ace-a54e-809842620f66
# ╠═ee7c8535-7d5f-41de-af1b-fcb8c5920bb9
# ╠═56f07a9f-f5ee-4976-a23c-7a7375f8cca6
# ╠═993c4916-f634-4233-ace1-187fef770e80
# ╟─dc5a54d6-8246-451d-95cb-59072a2bc96d
# ╠═7e776de3-3657-4640-b532-85a977a5dfd1
# ╠═697e5b51-e47e-49c0-92a0-b2fee46e118a
# ╟─5b28bf9d-15e1-4a21-81e8-e2d743aef64f
# ╠═da2fbdd7-7361-46a5-88cd-223e652fc2b4
# ╟─db43c2aa-32e0-46b7-9e33-dd9d695018ba
# ╠═ad1e7dab-45f0-4c64-b752-2409a5cc7adc
# ╟─7421f110-635e-423a-8462-c2d607906b08
# ╠═9c6603b4-4b36-4627-9617-759a8f5ebbff
# ╟─0e127352-ac5d-40ab-b5e7-333e6ca44fcf
# ╠═9e656cb6-9020-47c8-8159-2137eaa8dbab
# ╠═712b962e-5f25-43c8-8192-fa4467a7e05b
# ╟─23e69b3d-cfd5-4c7f-8121-64681ad920db
# ╠═4ec593f6-fb39-46a8-b4a4-0ab0c1bdf9b9
# ╠═4c629c00-67cf-4644-b082-4c1ed28d1569
# ╟─56a3eb41-99b2-43b8-9699-9043f5f2cb3a
# ╠═fd4ced3d-13ce-471b-90c5-a4cea8205e25
# ╠═1db03d96-43cd-4350-9374-8118339abb0f
# ╟─06a26ea2-d237-4cf3-b06e-93660e69d8fe
# ╠═016cf4c9-e5d2-4543-9f5c-fa65a93a3358
# ╠═76659148-7a00-491c-808e-5293819e64e3
# ╟─803cffb8-d162-432f-8ead-1586d9e9f244
# ╠═2718b0b9-d4eb-447e-8d8c-a3be4b71fce1
# ╟─fb89971a-a93b-4312-81d3-f61582e960c9
# ╠═7373c4b5-7e88-42ba-97e4-ba0f7186bc2d
# ╟─5238f479-13e1-4e9b-abbe-23deea9aa014
# ╠═663ece90-ad74-4303-91f4-5ca4b28be99c
# ╟─8506e3b5-6c74-45c6-a3cd-91bc9df23840
# ╠═7fdc4211-c5bf-4724-824d-2a23261dc415
# ╠═ecb2db1a-80a8-41e8-957b-58ffc0a6a4cf
# ╟─ee90ba64-1425-4174-9844-dd971b3128f6
# ╠═8ee28388-5495-4355-a5fd-25464defc4bb
# ╠═b10119aa-f27d-4b2e-af5b-d67f33f3c2e1
# ╟─6be7d7b1-6dcc-4bf8-bcbc-0b294d8e8a7e
# ╠═01f8938b-42d7-4d7f-bf21-011d92dcd925
# ╠═ea8185a1-2bf2-4d44-b8c2-354f4c13be80
# ╠═1f94401d-2e47-4fcc-8732-914553ac3230
# ╠═f83ef707-4068-4656-94da-1d22ca4c2726
# ╠═f78e359a-8dd7-4c55-82ec-e2a76323dc0d
# ╠═1e4daaee-9c0f-4723-885d-9cc5338933a8
# ╠═fa037c89-2d83-492d-bf91-f99c1b066074
# ╠═6175481b-f692-41de-9c9e-0d1e6f0709a1
