#Flow mapping using edgebundle package
#http://blog.schochastics.net/post/non-hierarchical-edge-bundling-in-r/
#Note that edgebundle imports reticulate and uses a pretty big python library (datashader). To install all dependencies, use


remotes::install_github("hafen/rminiconda")
remotes::install_github("schochastics/edgebundle")
library(edgebundle)
rminiconda::install_miniconda(name = "my_python")
py <- rminiconda::find_miniconda_python("my_python")
reticulate::use_python(py, required = TRUE)
install_bundle_py()
py_install(packages = 'datashader')

py <- rminiconda::find_miniconda_python("my_python")
reticulate::use_python(py, required = TRUE)

library(reticulate)
py_discover_config()
py_config()

myenvs=conda_list()

envname=myenvs$name[2]
use_condaenv("r-miniconda", required = TRUE)


#install.packages("remotes")
#remotes::install_github("schochastics/edgebundle")

#Another code snippet for conda install (1.4GB) from https://book.archnetworks.net/dataandworkspace#ShouldIInstall
#install.packages("edgebundle", "reticulate")
#library(edgebundle)
#library(reticulate)
#install_bundle_py(method = "auto", conda = "auto")


library(igraph)
library(readxl)
library(ggplot2)



#examples from the package
g <- graph_from_edgelist(
  matrix(c(1,12,2,11,3,10,4,9,5,8,6,7),ncol=2,byrow = T),F)
xy <- cbind(c(rep(0,6),rep(1,6)),c(1:6,1:6))

fbundle <- edge_bundle_force(g,xy,compatibility_threshold = 0.1)
head(fbundle)

g <- us_flights
plot(g)
xy <- cbind(V(g)$longitude, V(g)$latitude)
verts <- data.frame(x = V(g)$longitude, y = V(g)$latitude)

fbundle <- edge_bundle_force(g, xy, compatibility_threshold = 0.6)
sbundle <- edge_bundle_stub(g, xy)
hbundle <- edge_bundle_hammer(g, xy, bw = 0.7, decay = 0.5)
pbundle <- edge_bundle_path(g, xy, max_distortion = 12, weight_fac = 2, segments = 50)

states <- map_data("state")

p1 <- ggplot() +
  geom_path(data = sbundle, aes(x, y, group = group), 
            col = "#9d0191", size = 0.05) +
  geom_path(data = fbundle, aes(x, y, group = group), 
            col = "white", size = 0.005) +
  geom_point(data = verts, aes(x, y), 
             col = "#9d0191", size = 0.25) +
  geom_point(data = verts, aes(x, y), 
             col = "white", size = 0.25, alpha = 0.5) +
  geom_point(data = verts[verts$name != "", ], 
             aes(x, y), col = "white", size = 3, alpha = 1) +
  labs(title = "Force Directed Edge Bundling") +
  ggraph::theme_graph(background = "black") +
  theme(plot.title = element_text(color = "white"))

p1


#using my data
links<-read_excel("D:/Dropbox/Trader drafts/ngoc_only_exchange_links.xlsx")
nodes<-read_excel("D:/Dropbox/Trader drafts/ngoc_only_exchange_nodes.xlsx")


grf <- graph_from_data_frame(links, directed=TRUE, vertices=nodes)
E(grf)$x<-nodes$x
E(grf)$y<-nodes$y
V(grf)$amount<-links$amount
summary(grf)

print(grf, e=TRUE, v=TRUE)
plot(grf, edge.width=links$amount/1000)

if (require("maps")) {ggplot()+
    borders("world", ylim = c(10, 20), xlim = c(100, 112)) +
    scale_size_area() +
    coord_quickmap(ylim = c(10, 20), xlim = c(100, 112))+
    #Here is the magic bit that sets line transparency - essential to make the plot readable
    scale_alpha_continuous(range = c(0.1, 0.6)) +
    #Set black background, ditch axes and fix aspect ratio
    theme(panel.background = element_rect(fill = 'white', colour = 'white'))
}

plot(grf, edge.width=links$amount/1000)





xy <- cbind(V(grf)$x,V(grf)$y)
verts <- data.frame(x=V(grf)$x,y=V(grf)$y)
fbundle <- edge_bundle_force(grf,xy,compatibility_threshold = 0.6)
sbundle <- edge_bundle_stub(grf,xy)
hbundle <- edge_bundle_hammer(grf,xy,bw = 0.7,decay = 0.5)

#states <- map_data("state")

p2 <- ggplot()+
  geom_path(data = sbundle,aes(x,y),col="#9d0191",size=0.05)+
  geom_path(data = sbundle,aes(x,y),col="white",size=0.005)+
  geom_point(data = verts,aes(x,y),col="#9d0191",size=0.25)+
  geom_point(data = verts,aes(x,y),col="white",size=0.25,alpha=0.5)+
  geom_point(data=verts,aes(x,y), col="white", size=3,alpha=1)+
  labs(title="Forced Edge Bundling")+
  ggraph::theme_graph(background = "black")+
  theme(plot.title = element_text(color="white"))
p2

p2 <- ggplot()+
  geom_polygon(data=states,aes(long,lat,group=group),col="white",size=0.1,fill=NA)+
  geom_path(data = hbundle,aes(x,y,group=group),col="#9d0191",size=0.05)+
  geom_path(data = hbundle,aes(x,y,group=group),col="white",size=0.005)+
  geom_point(data = verts,aes(x,y),col="#9d0191",size=0.25)+
  geom_point(data = verts,aes(x,y),col="white",size=0.25,alpha=0.5)+
  geom_point(data=verts[verts$name!="",],aes(x,y), col="white", size=3,alpha=1)+
  labs(title="Hammer Edge Bundling")+
  ggraph::theme_graph(background = "black")+
  theme(plot.title = element_text(color="white"))


#smoothed flow graph
library(ggraph)
xxy <- cbind(nodes$x,nodes$y)
xy_dummy <- tnss_dummies(xxy,1)
gtree <- tnss_tree(grf,xxy,xy_dummy,1,gamma = 0.9)

smooth_df <- tnss_smooth(gtree,bw=5,n=20)

ggplot()+
  geom_polygon(data=us,aes(long,lat,group=group),fill="#FDF8C7",col="black")+
  geom_path(data = smooth_df,aes(x,y,group=destination,size=flow),
            lineend = "round",col="firebrick3",alpha=1)+
  theme_void()+
  scale_size(range=c(0.5,3),guide = "none")+
  labs(title="Migration from California (2010) - Flow map smoothed")


#Another example from https://www.r-bloggers.com/2021/10/smooth-flow-maps-and-a-new-edge-bundling-algorithm/
grff <- graph_from_data_frame(links,TRUE,nodes)
plot(grff) #works

root <- 2
xy <- cbind(nodes$x, nodes$y)
xy_dummy <- tnss_dummies(xy, 2)
gtree <- tnss_tree(grff, xy, xy_dummy, root = 2, gamma = 0.9, order = "near")
ggraph(gtree, "manual", x = V(gtree)$x, y = V(gtree)$y) +
  geom_polygon(data = us, aes(long, lat, group = group), fill = "#FDF8C7", col = "black") +
  geom_edge_link(aes(width = flow, col = sqrt((xy[root, 1] - ..x..)^2 + (xy[root, 2] - ..y..)^2)),
                 lineend = "round", show.legend = FALSE
  ) +
  scale_edge_width(range = c(0.5, 4), trans = "sqrt") +
  scale_edge_color_gradient(low = "#cc0000", high = "#0000cc") +
  geom_node_point(aes(filter = tnss == "leaf"), size = 1) +
  geom_node_point(aes(filter = (name == "California")), size = 5, shape = 22, fill = "#cc0000") +
  theme_graph() +
  labs(title = "Migration from California (2010) - Flow map")



smooth_df <- tnss_smooth(gtree, bw = 5, n = 20)

ggplot() +
  geom_polygon(data = us, aes(long, lat, group = group), fill = "#FDF8C7", col = "black") +
  geom_path(
    data = smooth_df, aes(x, y, group = destination, size = flow),
    lineend = "round", col = "firebrick3", alpha = 1
  ) +
  theme_void() +
  scale_size(range = c(0.5, 3), guide = "none") +
  labs(title = "Migration from California (2010) - Flow map smoothed")