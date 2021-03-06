all = {text: ""}
graph = {}
vectors = []
canvas = {}

window.getCanvas = () -> return canvas

$(document).ready -> 
	
	overlay = $("#overlay")
	canvas = Raphael(overlay.get(0))

	graph = []
	chrome.history.search(all, (history) ->

		for link in history
			chrome.history.getVisits({'url': link.url}, (visits) ->

				for visit in visits
					graph[visit.visitId] = {
						url: link.url
						title: link.title
						time: link.lastVisitTime
						parent: visit.referringVisitId
						children: []
					}		

				for vertex in graph
					graph[vertex.parent].children.push(vertex.id)

				return graph

			).then (graph) -> 
				console.log graph
				return graph

	)



	current = {time: 0}

	chrome.tabs.query({}, (tabs) -> 
		for tab in tabs
			for vertex in graph when vertex.url is tab.url
				if vertex.time > current_newest.time
					current = vertex 
			
			CreateVector(current)

	)


window.CreateVector = (vertex) -> 
	
	left = vectors.length * 220;
	$vector = $("<div/>", class: 'vector', style:"left: "+left+"px; top: 0;")
	$("#overlay").append($vector)
	
	recurse = (vertex) -> 

		$vector.append(BuildDiv(vertex.time, vertex.title, vertex.url))
		recurse(graph[vertex.parent]) if vertex.parent?
	
	recurse(vertex)

	vectors.push($vector)


window.BuildDiv = (bottomTime, title, url) -> 

#	console.log graph

	$rect = $("<div/>", class: "link", text: "#{title}")

	return $rect





###
	HistoryItem

	id ( string )
		The unique identifier for the item.
	url ( optional string )
		The URL navigated to by a user.
	title ( optional string )
		The title of the page when it was last loaded.
	lastVisitTime ( optional double )
		When this page was last loaded, represented in milliseconds since the epoch.
	visitCount ( optional integer )
		The number of times the user has navigated to this page.
	typedCount ( optional integer )
		The number of times the user has navigated to this page by typing in the address.

	VisitItem

	id ( string )
		The unique identifier for the item.
	visitId ( string )
		The unique identifier for this visit.
	visitTime ( optional double )
		When this visit occurred, represented in milliseconds since the epoch.
	referringVisitId ( string )
		The visit ID of the referrer.

###
