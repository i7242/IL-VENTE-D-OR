### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 410132e0-3cc7-11eb-3807-e197a261603b
begin
	using Plots
	using LinearAlgebra:norm
end

# ╔═╡ a414cba8-3cc2-11eb-264d-19dadef34cf6
md"""# K-means Clustering Algorithm"""

# ╔═╡ e7283628-3cc2-11eb-2f1b-b75fa1d41266
md"""> try tom implement K-means algorithm. could be more generic and efficient"""

# ╔═╡ 0dcaa130-3cc3-11eb-1490-63dc1c8fc22c
md"""
## Definition
* Assume inputs are represented as $m \times n$ matrix, where:
  * each column is a data point
  *  $m$ is the dimension of vector
  *  $n$ is the number of points
"""

# ╔═╡ ba19afe0-3cc7-11eb-04fa-47d5ee5cad1e
md"""## Implementation"""

# ╔═╡ c26b77d2-3cd1-11eb-36ab-d9af03a29a25
md"""> get random points, with assumed clusters"""

# ╔═╡ 8f049792-3cc3-11eb-10af-5955f444be1f
#=
  get random point set represented as array of real numbers
    Attention: these parameters are only used to generate random points,
      they are not constraints on results!
    n: number of points to generate
    d: dimension of points
    r: radius around zero point
    k: number of groups (can't be guaranteed actually, just random generated)
    σ: deviation for points around k centers
=#

function get_random_points(n::Int64, d::Int64=2, r::Int64=4,
		k::Int64=2, σ::Float64=1.0)::Tuple{Array{Float64, 2}, Array{Float64, 2}}
	
	centroids = (rand(Float64, (d, k)) .-0.5) .* r
	deviations = rand(Float64, (d, n)) .* σ
	sub_count = floor(Int, n/k)
	# how to vectorize this for loop ???
	for idx in 1:size(deviations)[2]
		deviations[:,idx] .+= centroids[:, min(ceil(Int, idx/sub_count), k)]
	end
	return deviations, centroids
end

# ╔═╡ bf757172-3cd1-11eb-2bc6-5b69266bf785
md"""> k-means clustering"""

# ╔═╡ f28a1aac-3cd1-11eb-2a59-adc648860893
function k_means_clustering(points::Array{Float64, 2}, k::Int)::Array{Int64,1}
	new_tags = rand(1:k,size(points)[2])
	old_tags = zeros(Int64, k)
	centroids = rand(Float64, (size(points)[1], k))
	iterations = 0
	while new_tags != old_tags && iterations < 5000
		iterations += 1
		old_tags = copy(new_tags)
		for i in 1:size(points)[2]
			new_tags[i] = argmin(sqrt.(sum((centroids .- points[:,i]).^2, dims=1)))[2]
		end
		for i in 1:k
			centroids[:, i] = sum(points[:, new_tags .== i], dims=2)/
				size(findall(x->x==i, new_tags))[1]
		end
	end
	return new_tags
end

# ╔═╡ 5a3f2ed6-3cfb-11eb-1c88-2fc2d7ec790f
md"""## Test Cases"""

# ╔═╡ 8369cdb4-3cc6-11eb-1b4c-51aef94a3c6b
points, centroids = get_random_points(100, 2, 2, 3)

# ╔═╡ 8267e0ae-3cf8-11eb-1267-41af3303285d
tags = k_means_clustering(points, 3)

# ╔═╡ 6b329692-3cc7-11eb-215c-15b9117b6ef0
begin
	plt = scatter(points[1,:], points[2,:], label="")
	plt = scatter!(centroids[1,:], centroids[2,:], label="")
end

# ╔═╡ 7037e2ec-3cfa-11eb-3596-078cfa9a0cbe
begin
	cluster_1 = tags .== 1
	cluster_2 = tags .== 2
	cluster_3 = tags .== 3
	result_plt = scatter(points[1,cluster_1], points[2,cluster_1], label="")
	result_plt = scatter!(points[1,cluster_2], points[2,cluster_2], label="")
	result_plt = scatter!(points[1,cluster_3], points[2,cluster_3], label="")
end

# ╔═╡ Cell order:
# ╟─a414cba8-3cc2-11eb-264d-19dadef34cf6
# ╟─e7283628-3cc2-11eb-2f1b-b75fa1d41266
# ╠═410132e0-3cc7-11eb-3807-e197a261603b
# ╟─0dcaa130-3cc3-11eb-1490-63dc1c8fc22c
# ╟─ba19afe0-3cc7-11eb-04fa-47d5ee5cad1e
# ╟─c26b77d2-3cd1-11eb-36ab-d9af03a29a25
# ╠═8f049792-3cc3-11eb-10af-5955f444be1f
# ╟─bf757172-3cd1-11eb-2bc6-5b69266bf785
# ╠═f28a1aac-3cd1-11eb-2a59-adc648860893
# ╟─5a3f2ed6-3cfb-11eb-1c88-2fc2d7ec790f
# ╠═8369cdb4-3cc6-11eb-1b4c-51aef94a3c6b
# ╠═8267e0ae-3cf8-11eb-1267-41af3303285d
# ╠═6b329692-3cc7-11eb-215c-15b9117b6ef0
# ╠═7037e2ec-3cfa-11eb-3596-078cfa9a0cbe
