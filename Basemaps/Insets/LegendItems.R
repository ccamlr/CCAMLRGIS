#Legend items for Basemaps (type ?add_Legend for details)

#Set parameters that apply to all items
i_Shape="rectangle"
i_Shplwd=2
i_fontsize=0.8
i_STSpace=3
i_RectW=6
i_RectH=4.5

#Build items
L_RBs=list(
  Text="Research Blocks", 
  ShpBord="darkgreen",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_ASDs=list(
  Text=paste0("Areas, Subareas","\n","and Divisions"), 
  ShpBord="black",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_SSMUs=list(
  Text=paste0("Small Scale","\n","Management Units"), 
  ShpBord="orange",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_MAs=list(
  Text="Management Areas", 
  ShpBord="darkred",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_SSRUs=list(
  Text=paste0("Small Scale","\n","Research Units"), 
  ShpBord="gray40",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_EEZs=list(
  Text=paste0("Exclusive Economic","\n","Zones"), 
  ShpBord="purple",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_ADFs=list(
  Text="Areas of directed fishing", 
  ShpBord="darkred",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_MPAs=list(
  Text="Marine Protected Area", 
  ShpBord="red",
  ShpFill=rgb(1,0.5,0,0.4),
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH
)

L_GPZs=list(
  Text="General Protection Zone", 
  ShpBord=NA,
  ShpFill="white",
  Shape=i_Shape,
  Shplwd=i_Shplwd,
  fontsize=i_fontsize,
  STSpace=i_STSpace,
  RectW=i_RectW,
  RectH=i_RectH,
  ShpHash=T,
  Hashcol="grey30",
  Hashangle=45,
  Hashspacing=0.5,
  Hashwidth=0.25
)