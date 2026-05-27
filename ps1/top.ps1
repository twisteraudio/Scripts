While(1) 
	{
	gps | 
	sort-object -des cpu | 
	select -f 15 |
	format-table ; sleep 1; clear
}
