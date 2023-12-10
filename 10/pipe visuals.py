print( #cause it looks epic and cause my lua is :( about utf-8
	open("input.txt", "r", encoding="utf-8").read()
	.replace("|", "║").replace("7", "╗").replace("J", "╝").replace("L", "╚").replace("F", "╔").replace("-", "═")
)
""" Example output:
.╔╗╔╗╔╗╔╗╔╗╔╗╔╗╔═══╗
.║╚╝║║║║║║║║║║║║╔══╝
.╚═╗╚╝╚╝║║║║║║╚╝╚═╗.
╔══╝╔══╗║║╚╝╚╝.╔╗╔╝.
╚═══╝╔═╝╚╝....╔╝╚╝..
...╔═╝╔═══╗...╚╗....
..╔╝╔╗╚╗╔═╝╔╗..╚═══╗
..╚═╝╚╗║║╔╗║╚╗╔═╗╔╗║
.....╔╝║║║║║╔╝╚╗║║╚╝
.....╚═╝╚╝╚╝╚══╝╚╝..
"""