### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ b5467830-d6d3-11eb-3ef0-7db3eceb564e
using DataFrames

# ╔═╡ 235a6b39-f012-40e2-8a01-7a2282e451df
using Statistics # needed for mean

# ╔═╡ 0d742008-b145-46f3-9227-555b7d3f3b50

using CategoricalArrays

# ╔═╡ f3e7ecef-fda6-45ae-8f65-a14b06c6daa9
md"""
# Introduction to DataFrames
"""

# ╔═╡ cfa2a140-1156-4227-a699-422375eb2aab
md"""
## Handling missing values
A singelton type `Missing` allows us to deal with missing values.
"""

# ╔═╡ ef5dd8ca-30e8-4e74-8413-6a77630d9366
missing, typeof(missing)

# ╔═╡ 204c3aad-2796-45f4-bf8b-af2bc95212db
md"Arrays automatically create an appropriate union type."

# ╔═╡ 9165086d-a293-445f-a5a0-7c8d72496b08
x = [1, 2, missing, 3]

# ╔═╡ 92cd7ed0-772b-4aa5-9179-87d6947a033b
md"`ismissing` checks if passed value is missing."

# ╔═╡ 9a19b9e7-fcb1-4e46-a0fb-50f3a4925f08
ismissing(1), ismissing(missing), ismissing(x), ismissing.(x)

# ╔═╡ 0e1db2e2-c11c-4768-869c-8f747010b036
md"""
We can extract the type combined with `Missing` from a `Union` via `nonmissingtype`

(This is useful for arrays!)
"""

# ╔═╡ 4e98e752-a3d2-44c7-8248-6c47ad2127a5
eltype(x), nonmissingtype(eltype(x))

# ╔═╡ c48bb959-b446-4aea-a279-626258de55ff
md"`missing` comparisons produce `missing`."

# ╔═╡ 1bb8483c-c333-48a3-85c8-f6d2adf0d634
missing == missing, missing != missing, missing < missing

# ╔═╡ d2fd2536-7d83-43e7-b425-58bbf5a5e9eb
md"This is also true when `missing`s are compared with values of other types."

# ╔═╡ f7d6ea20-f5f2-4924-8884-bb375c952885
1 == missing, 1 != missing, 1 < missing

# ╔═╡ 2c7ea4c1-0768-4140-9294-f7e807fdd3e3
md"""
`isequal`, `isless`, and `===` produce results of type `Bool`. Notice that `missing` is considered greater than any numeric value.
"""

# ╔═╡ 8c38bb66-58a9-4a8d-b687-062b96d93b72
isequal(missing, missing), missing === missing, isequal(1, missing), isless(1, missing)

# ╔═╡ 7e9a9e4d-5cde-4f39-9cfe-6d73fe40e731
md"""
In the next few examples, we see that many (not all) functions handle `missing`.
"""

# ╔═╡ 2d22fc35-fc7d-49cc-a2fd-d01e8e45ca1f
map(x -> x(missing), [sin, cos, zero, sqrt]) # part 1

# ╔═╡ bb66f850-e9d9-43a6-b9dd-bf5c142c33a7
map(x -> x(missing, 1), [+, - , *, /, div]) # part 2

# ╔═╡ d2264df1-421c-4ea7-834c-98f17e0ebbe4
map(x -> x([1, 2, missing]), [minimum, maximum, extrema, mean, float]) # part 3

# ╔═╡ 96ec7632-0851-40e2-a36f-1d07be98753f
md"""
`skipmissing` returns iterator skipping missing values. We can use `collect` and `skipmissing` to create an array that excludes these missing values.
"""

# ╔═╡ 705040ca-81a7-4af2-b1be-ffe7017c25ea
collect(skipmissing([1, missing, 2, missing]))

# ╔═╡ 06c03401-c3d7-4304-8eb2-1dc55cc07003
md"""
Here we use `replace` to create a new array that replaces all missing values with some value (`NaN` in this case).
"""

# ╔═╡ dd3c6d06-a1a9-4d18-9a7f-ebf422f5412c
replace([1.0, missing, 2.0, missing], missing=>NaN)

# ╔═╡ 0443006a-d239-4238-b5dc-16ffdf7fc210
md"Another way to do this:"

# ╔═╡ 9a352aef-0318-43a6-9197-60998b6119b1
coalesce.([1.0, missing, 2.0, missing], NaN)

# ╔═╡ 29881832-acd2-426f-a4fb-dac7d5629e83
md"""
You can also use recode from [CategoricalArrays.jl](https://github.com/JuliaData/CategoricalArrays.jl) if you have a default output value.
"""

# ╔═╡ 0b3247d7-603b-4a39-b679-7c2195958683
recode([1.0, missing, 2.0, missing], false, missing=>true)

# ╔═╡ bd977eae-ef6f-4b1f-9ba1-7dc1af45257e
md"""
There are also replace! and recode! functions that work in place.

Here is an example how you can do to missing inputation in a data frame.
"""

# ╔═╡ 7b44d6aa-16f6-4a43-baf0-94481a1f4013
df = DataFrame(a=[1, 2, missing], b=["a", "b", missing])

# ╔═╡ 5568bd06-cf85-4bcc-9453-8df21bb4f57d
md"We change `df.a` vector in place."

# ╔═╡ caf67143-bc45-491d-8772-b1b2020803b1
replace!(df.a, missing => 100)

# ╔═╡ f79ea82d-7757-45c8-9788-4cff9e80efd7
df

# ╔═╡ ffdeef02-83e5-4e8e-8a58-14b974d1d175
md"""
Now we overwrite `df.b` with a new vector, because the replacement type is different than what `eltype(df.b)` accepts.
"""

# ╔═╡ 018d5475-8013-44f6-9185-47c1e7af0f82
eltype(df.b)

# ╔═╡ 05bd51de-0890-41cb-96e6-1a128338fb3e
df.b = coalesce.(df.b, 100)

# ╔═╡ 2a176003-34ad-45af-ab76-a7a1c292d113
df

# ╔═╡ cd07704b-ee81-426f-80a8-c5e1d1bfcdbf
md"""
You can use `unique` or `levels` to get unique values with or without missings, respectively.
"""

# ╔═╡ ed3e23b3-2917-4930-a3e3-e383839352b2
unique([1, missing, 2, missing]), levels([1, missing, 2, missing])

# ╔═╡ 494856d7-1a99-41f7-848a-9d84107d881f
md"""
In this next example, we convert `a` to `b` with `allowmissing`, where `b` has a type that accepts `missing`s.
"""

# ╔═╡ 5bae99bb-12b3-493c-8c1f-bee6c6628fa6
begin
	a = [1, 2, 3]
	b = allowmissing(a)
end

# ╔═╡ c71156e2-cb35-4abf-a6cb-d39b18a2c0d2
md"""
Then, we convert back with `disallowmissing`. This would fail if `b` contained missing values!
"""

# ╔═╡ 07fef3eb-a4bc-4dd7-80f9-ea1c28b21c1f
begin
	c = disallowmissing(b)
	a, b, c
end

# ╔═╡ 13570a12-97ac-40d6-8f84-9183b0ec010b
md"""
`disallowmissing` has `error` keyword argument that can be used to decide how it should behave when it encounters a column that actually contains a missing value.
"""

# ╔═╡ d6d2edf9-dfba-4e33-b676-d91a72e7bc13
df1 = allowmissing(DataFrame(ones(2,3), :auto))

# ╔═╡ 56d4fadf-6b25-41f5-accf-d3ebbcd44042
df1[1, 1] = missing

# ╔═╡ de12840c-4ddf-48f5-87d2-761f12811db8
df1

# ╔═╡ 45988e4a-a6cf-4dcb-94b3-27aa15f51c46
eltype.(eachcol(df1))

# ╔═╡ f22aef68-5830-4345-b6c3-f01b1aada980
disallowmissing(df1) # an error is thrown

# ╔═╡ d7efe3e2-8dc2-4134-9001-abe134543319
disallowmissing!(df1, error=false) # column :x1 is left untouched as it contains missing

# ╔═╡ c98c6dfb-e7f8-49dd-a7af-67b9b10c5cf1
md"""
Note that columns `:x2` and `:x3` have type of `Float64`, but column `:x1` is still of type `Union{Missing, Float64}`.
"""

# ╔═╡ 1565a9e1-4df9-4dfa-aef5-6861de0668c6
eltype.(eachcol(df1))

# ╔═╡ e0b83e8a-cb80-4ba3-b7bd-b1f456df31e3
md"""
In this next example, we show that the type of each column in `df2` is initially `Int64`. After using `allowmissing!` to accept missing values in columns 1 and 3, the types of those columns become `Union{Int64, Missing}`.
"""

# ╔═╡ 562097ec-1f8f-465b-b266-0c68588cd480
begin
	df2 = DataFrame(rand(Int, 2, 3), :auto)
	column_types_defore = eltype.(eachcol(df2))
	allowmissing!(df2, 1) # make first column accept missings
	allowmissing!(df2, :x3) # make :x3 column accept missings
	column_types_after = eltype.(eachcol(df2))
	(Before=column_types_defore, After=column_types_after)
end

# ╔═╡ f5903c13-0b44-4bbf-8718-fdc4bf6c8c28
md"""
In this next example, we'll use `completecases` to find all the rows of a data frame that have complete data.
"""

# ╔═╡ 94fe6481-0045-41dc-a9ab-34201fef6a99
df3 = DataFrame(A=[1, missing, 3, 4], B=["A", "B", missing, "C"])

# ╔═╡ 2096879a-c0f5-4956-86f7-3bed623e9c3d
"Complete cases = $(completecases(df3))"

# ╔═╡ ca1d7d86-ee75-45b0-ac68-f690da94d700
md"""
We can use `dropmissing` or `dropmissing!` to remove the rows with incomplete data from a data frame and either create a new data frame or mutate the original in-place.
"""

# ╔═╡ 5b775c1b-c921-44b3-acf0-698835a75cfd
begin
	df33 = dropmissing(df3)
	dropmissing!(df3)
end

# ╔═╡ c200cbfa-5c91-4b81-916b-0c0cb9174195
df3

# ╔═╡ b9a60ad2-18b8-49a9-9da2-a63b43bcfc27
df33 == df3

# ╔═╡ 0e268022-8d95-4e66-aeed-155225281c85
md"""
When we call `describe` on a data frame with missing values dropped, the columns do not allow missing values any more by default.
"""

# ╔═╡ 6d9ee94d-8c91-499d-9671-7b5ff1e4f9f2
describe(df3)

# ╔═╡ 9213991a-98cd-4a69-8abd-eb80da0903c7
md"""
Alternatively you can pass `disallowmissing` keyword argument to `dropmissing` and `dropmissing!.`
"""

# ╔═╡ 315ce54c-a82d-4441-a53e-b1c8afd048e0
df4 = DataFrame(A=[1, missing, 3, 4], B=["A", "B", missing, "C"])

# ╔═╡ fcbb5a01-edc7-45ee-8e41-48a47ca0bf76
dropmissing!(df4, disallowmissing=false)

# ╔═╡ 62e6c833-9d4f-4f9c-8ef5-c62426f92368
md"""
### Making functions missing-aware
If we have a function that does not handle missing values we can wrap it using `passmissing` function so that if any of its positional arguments is missing we will get a missing value in return. In the example below we change how string function behaves:
"""

# ╔═╡ 1899700e-ae02-4847-b567-1804f33fd9a7
string(missing)

# ╔═╡ c9093efc-2827-494d-8379-4c8a7b714aca
string(missing, " ", missing)

# ╔═╡ 586599bd-73f7-4e3b-bd7b-9e13063bc0e0
string(1, 2, 3)

# ╔═╡ fe466b95-1179-434c-a3b4-6bf9430a7df2
lift_string = passmissing(string)

# ╔═╡ ae38afe5-53aa-48a4-98b6-ff5e70d490dd
lift_string(missing)

# ╔═╡ 222a8d80-a220-497c-994d-9d7c28b263bf
lift_string(missing, " ", missing)

# ╔═╡ 15a390fd-46d0-4bb1-b25d-7312ef4ba192
lift_string(1, 2, 3)

# ╔═╡ 467f8f12-5ff9-470f-b038-3c4ac1ed2b19
md"""
### Aggregating rows containing missing values
Create an example data frame containing missing values:
"""

# ╔═╡ 39d16e61-55dc-4727-81dc-3d81891bb63b
df5 = DataFrame(a=[1, missing, missing], b=[1, 2, missing])

# ╔═╡ bfab35f9-06c2-4eba-8379-efd489bef69e
md"If we just run sum on the rows we get two missing entries:"

# ╔═╡ c7923fe4-b421-4a26-b594-e63b1f170ec3
sum.(eachrow(df5))

# ╔═╡ cc758597-0374-414b-a63f-fa205fd7268e
md"One can apply `skipmissing` on the rows to avoid this problem:"

# ╔═╡ 37cda392-fb20-4dfe-a27e-d72424781914
sum.(skipmissing.(eachrow(df5)))

# ╔═╡ edbe779f-a862-4d36-b75e-791030014a61
md"""
However, we get an error. The problem is that the last row of `df5` contains only missing values, and since `eachrow` is type unstable the `eltype` of the result of `skipmissing` is unknown (so it is marked `Any`).
"""

# ╔═╡ 75574b65-b860-45a5-aab3-3b0af96a8006
collect(skipmissing(eachrow(df5)[end]))

# ╔═╡ 12caf1ed-1ca0-4c32-8fe8-ae00c0455b85
md"""
In such cases it is useful to switch to `Tables.namedtupleiterator` which is type stable as discussed in `01_constructors.jl` notebook.
"""

# ╔═╡ 7c338b48-1ec9-4151-973a-f0dd86a99c12
sum.(skipmissing.(Tables.namedtupleiterator(df5)))

# ╔═╡ Cell order:
# ╟─f3e7ecef-fda6-45ae-8f65-a14b06c6daa9
# ╠═b5467830-d6d3-11eb-3ef0-7db3eceb564e
# ╟─cfa2a140-1156-4227-a699-422375eb2aab
# ╠═ef5dd8ca-30e8-4e74-8413-6a77630d9366
# ╟─204c3aad-2796-45f4-bf8b-af2bc95212db
# ╠═9165086d-a293-445f-a5a0-7c8d72496b08
# ╟─92cd7ed0-772b-4aa5-9179-87d6947a033b
# ╠═9a19b9e7-fcb1-4e46-a0fb-50f3a4925f08
# ╟─0e1db2e2-c11c-4768-869c-8f747010b036
# ╠═4e98e752-a3d2-44c7-8248-6c47ad2127a5
# ╟─c48bb959-b446-4aea-a279-626258de55ff
# ╠═1bb8483c-c333-48a3-85c8-f6d2adf0d634
# ╟─d2fd2536-7d83-43e7-b425-58bbf5a5e9eb
# ╠═f7d6ea20-f5f2-4924-8884-bb375c952885
# ╟─2c7ea4c1-0768-4140-9294-f7e807fdd3e3
# ╠═8c38bb66-58a9-4a8d-b687-062b96d93b72
# ╟─7e9a9e4d-5cde-4f39-9cfe-6d73fe40e731
# ╠═2d22fc35-fc7d-49cc-a2fd-d01e8e45ca1f
# ╠═bb66f850-e9d9-43a6-b9dd-bf5c142c33a7
# ╠═235a6b39-f012-40e2-8a01-7a2282e451df
# ╠═d2264df1-421c-4ea7-834c-98f17e0ebbe4
# ╟─96ec7632-0851-40e2-a36f-1d07be98753f
# ╠═705040ca-81a7-4af2-b1be-ffe7017c25ea
# ╟─06c03401-c3d7-4304-8eb2-1dc55cc07003
# ╠═dd3c6d06-a1a9-4d18-9a7f-ebf422f5412c
# ╟─0443006a-d239-4238-b5dc-16ffdf7fc210
# ╠═9a352aef-0318-43a6-9197-60998b6119b1
# ╟─29881832-acd2-426f-a4fb-dac7d5629e83
# ╠═0d742008-b145-46f3-9227-555b7d3f3b50
# ╠═0b3247d7-603b-4a39-b679-7c2195958683
# ╟─bd977eae-ef6f-4b1f-9ba1-7dc1af45257e
# ╠═7b44d6aa-16f6-4a43-baf0-94481a1f4013
# ╟─5568bd06-cf85-4bcc-9453-8df21bb4f57d
# ╠═caf67143-bc45-491d-8772-b1b2020803b1
# ╠═f79ea82d-7757-45c8-9788-4cff9e80efd7
# ╟─ffdeef02-83e5-4e8e-8a58-14b974d1d175
# ╠═018d5475-8013-44f6-9185-47c1e7af0f82
# ╠═05bd51de-0890-41cb-96e6-1a128338fb3e
# ╠═2a176003-34ad-45af-ab76-a7a1c292d113
# ╟─cd07704b-ee81-426f-80a8-c5e1d1bfcdbf
# ╠═ed3e23b3-2917-4930-a3e3-e383839352b2
# ╟─494856d7-1a99-41f7-848a-9d84107d881f
# ╠═5bae99bb-12b3-493c-8c1f-bee6c6628fa6
# ╟─c71156e2-cb35-4abf-a6cb-d39b18a2c0d2
# ╠═07fef3eb-a4bc-4dd7-80f9-ea1c28b21c1f
# ╟─13570a12-97ac-40d6-8f84-9183b0ec010b
# ╠═d6d2edf9-dfba-4e33-b676-d91a72e7bc13
# ╠═56d4fadf-6b25-41f5-accf-d3ebbcd44042
# ╠═de12840c-4ddf-48f5-87d2-761f12811db8
# ╠═45988e4a-a6cf-4dcb-94b3-27aa15f51c46
# ╠═f22aef68-5830-4345-b6c3-f01b1aada980
# ╠═d7efe3e2-8dc2-4134-9001-abe134543319
# ╟─c98c6dfb-e7f8-49dd-a7af-67b9b10c5cf1
# ╠═1565a9e1-4df9-4dfa-aef5-6861de0668c6
# ╟─e0b83e8a-cb80-4ba3-b7bd-b1f456df31e3
# ╠═562097ec-1f8f-465b-b266-0c68588cd480
# ╟─f5903c13-0b44-4bbf-8718-fdc4bf6c8c28
# ╠═94fe6481-0045-41dc-a9ab-34201fef6a99
# ╠═2096879a-c0f5-4956-86f7-3bed623e9c3d
# ╟─ca1d7d86-ee75-45b0-ac68-f690da94d700
# ╠═5b775c1b-c921-44b3-acf0-698835a75cfd
# ╠═c200cbfa-5c91-4b81-916b-0c0cb9174195
# ╠═b9a60ad2-18b8-49a9-9da2-a63b43bcfc27
# ╟─0e268022-8d95-4e66-aeed-155225281c85
# ╠═6d9ee94d-8c91-499d-9671-7b5ff1e4f9f2
# ╟─9213991a-98cd-4a69-8abd-eb80da0903c7
# ╠═315ce54c-a82d-4441-a53e-b1c8afd048e0
# ╠═fcbb5a01-edc7-45ee-8e41-48a47ca0bf76
# ╟─62e6c833-9d4f-4f9c-8ef5-c62426f92368
# ╠═1899700e-ae02-4847-b567-1804f33fd9a7
# ╠═c9093efc-2827-494d-8379-4c8a7b714aca
# ╠═586599bd-73f7-4e3b-bd7b-9e13063bc0e0
# ╠═fe466b95-1179-434c-a3b4-6bf9430a7df2
# ╠═ae38afe5-53aa-48a4-98b6-ff5e70d490dd
# ╠═222a8d80-a220-497c-994d-9d7c28b263bf
# ╠═15a390fd-46d0-4bb1-b25d-7312ef4ba192
# ╟─467f8f12-5ff9-470f-b038-3c4ac1ed2b19
# ╠═39d16e61-55dc-4727-81dc-3d81891bb63b
# ╟─bfab35f9-06c2-4eba-8379-efd489bef69e
# ╠═c7923fe4-b421-4a26-b594-e63b1f170ec3
# ╟─cc758597-0374-414b-a63f-fa205fd7268e
# ╠═37cda392-fb20-4dfe-a27e-d72424781914
# ╟─edbe779f-a862-4d36-b75e-791030014a61
# ╠═75574b65-b860-45a5-aab3-3b0af96a8006
# ╟─12caf1ed-1ca0-4c32-8fe8-ae00c0455b85
# ╠═7c338b48-1ec9-4151-973a-f0dd86a99c12
