function dictionaryToString(dictionary, tabs)
{
	if (tabs == null) { tabs = 0; }
		
	var outputString = "";
	if (dictionary instanceof Dictionary)
	{
		var keys = dictionary.keys();
        for(var i = 0; i < keys.size(); i++) 
        {
        	for (var j = 0; j < tabs; j++)
        	{	
        		outputString += "	";
        	}
            
            outputString += Lang.format("$1$: $2$", [ keys[i], dictionaryToString(dictionary[keys[i]], tabs + 1) ]);
            
            if (i < keys.size() - 1)
            {
            	outputString += "\n";
            }
        }    		
	}
	else
	{
		outputString = dictionary;
	}
	return outputString;
}

function replace(string, find, replace)
{
	if (!(string instanceof String))
		{ return "String is not a string"; }

	if (!(find instanceof String))
		{ return "Find is not a string"; }
		
	if (find.length() <= 0)
		{ return "Find is empty"; }
		
	if (!(replace instanceof String))
		{ return "Replace is not a string"; }

	string = string.toCharArray();
	find = find.toCharArray();

	var newString = "";
	var matchFound = false;
	for (var i = 0; i < string.size(); i++)
	{
		matchFound = true;
		for (var j = 0; j < find.size(); j++)
		{
			if (string[i + j] != find[j])
			{
				matchFound = false;
				break;
			}
		}
		if (matchFound)
		{
			newString += replace;
			i += find.size() - 1;
		}
		else
		{
			newString += string[i];
		}
	}
	return newString;
}