GetPerp=function(Input,d=Pwidth){
  x=NULL
  y=NULL
  #First get Perp for first point
  m=(Input$y[1]-Input$y[2])/(Input$x[1]-Input$x[2])
  if(m==0){m=1e-12}
  x_1=Input$x[1]+sqrt(d^2/(1+(1/m^2)))
  y_1=Input$y[1]-(1/m)*(x_1-Input$x[1])
  x_2=Input$x[1]-sqrt(d^2/(1+(1/m^2)))
  y_2=Input$y[1]-(1/m)*(x_2-Input$x[1])
  x=c(x,x_1,x_2)
  y=c(y,y_1,y_2)
  #Then loop over other points
  for(i in seq(2,nrow(Input))){
    m=(Input$y[i]-Input$y[i-1])/(Input$x[i]-Input$x[i-1])
    if(m==0){m=1e-12}
    x_1=Input$x[i]+sqrt(d^2/(1+(1/m^2)))
    y_1=Input$y[i]-(1/m)*(x_1-Input$x[i])
    x_2=Input$x[i]-sqrt(d^2/(1+(1/m^2)))
    y_2=Input$y[i]-(1/m)*(x_2-Input$x[i])
    x=c(x,x_1,x_2)
    y=c(y,y_1,y_2)
  }
  return(data.frame(x=x,y=y))
}