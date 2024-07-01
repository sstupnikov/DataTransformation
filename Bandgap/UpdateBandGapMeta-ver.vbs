Dim RSN, objXML, objRootElement 

Function myDoJob()
	myInit() 
	GenerateIML()
end Function

Function myInit()
	Set objXML = CreateObject("Msxml2.DOMDocument")
	Set RSN = CreateObject("ADODB.Recordset")
end function

Function GenerateIML()
	objXML.loadXML("<?xml version=""1.0"" encoding=""windows-1251"" ?>" & ctrln & "<MetaBase date=""" & Mydate & """ version=""1.0""  xmlns=""http://victest/MUService.xsd"" />")
	Set objRootElement = objXML.documentElement
	StrMsg = ProcessXML(objRootElement)
end Function

function ProcessXML(tmpElement)
	ProcessXML = ProcessSystemInfo(tmpElement)
	ProcessXML = ProcessPropertiesInfo(tmpElement)
	ProcessXML = ProcessDBContentInfo(tmpElement)
end function

function ProcessSystemInfo(objRootElement)
Dim tmp, tmpLink, tmpLink2
Dim SubstanceID, UpdateStatus, Compound, Elements

	RSN.Open "SELECT * FROM _SubstancesConv WHERE UpdateStatus>0" 

	if NOT RSN.EOF Then
		Set tmp = objXML.createNode(1, "SystemInfo", "")
		objRootElement.appendChild(tmp)
	end if
	Do while NOT RSN.EOF
		SubstanceID = RSN("SubstanceID")
		UpdateStatus = RSN("UpdateStatus")
		Compound = ""&RSN("Compound")
		Elements = ""&RSN("Elements")
		Set tmpLink = objXML.createNode(1, "SystemInfoItem", "")

		Set tmpLink2 = objXML.createNode(1, "SystemID", "")
		tmpLink2.text = SubstanceID
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "Elements", "")
		tmpLink2.text = Elements
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "SystemInfo", "")
		tmpLink2.text = Compound
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "Description", "")
		tmpLink2.text = ""
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "UpdateStatus", "")
		tmpLink2.text = UpdateStatus
		tmpLink.appendChild(tmpLink2)

		tmp.appendChild(tmpLink)
		XMLSystemItems = XMLSystemItems + 1
		RSN.MoveNext
	Loop
end function

function ProcessPropertiesInfo(objRootElement)
Dim tmp, tmpLink, tmpLink2, theDate
Dim NOMPROP, UpdateStatus, NAZVPROP, HTML

	RSN.Open "SELECT * FROM _PropertiesConv WHERE UpdateStatus>0" 

	if NOT RSN.EOF Then
		Set tmp = objXML.createNode(1, "PropertiesInfo", "")
		objRootElement.appendChild(tmp)
	end if
	Do while NOT RSN.EOF
		NOMPROP = RSN("NOMPROP")
		UpdateStatus = RSN("UpdateStatus")
		NAZVPROP = ""&RSN("NAZVPROP")
		HTML = ""&RSN("HTML")
		Set tmpLink = objXML.createNode(1, "PropertiesInfoItem", "")

		Set tmpLink2 = objXML.createNode(1, "PropID", "")
		tmpLink2.text = NOMPROP
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "Name", "")
		tmpLink2.text = NAZVPROP
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "Description", "")
		tmpLink2.text = ""
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "WWWTemplatePage", "")
		tmpLink2.text = HTML
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "UpdateStatus", "")
		tmpLink2.text = UpdateStatus
		tmpLink.appendChild(tmpLink2)

		tmp.appendChild(tmpLink)
		XMLPropertiesItems = XMLPropertiesItems + 1
		RSN.MoveNext
	Loop
end function

function ProcessDBContentInfo(objRootElement)
Dim tmp, tmpLink, tmpLink2, theDate
Dim SubstanceID, NOMPROP, UpdateStatus

	RSN.Open "SELECT * FROM _DBContentConv WHERE UpdateStatus>0" 

	if NOT RSN.EOF Then
		Set tmp = objXML.createNode(1, "DBContent", "")
		objRootElement.appendChild(tmp)
	end if
	Do while NOT RSN.EOF
		SubstanceID = RSN("SubstanceID")
		NOMPROP = RSN("NOMPROP")
		UpdateStatus = RSN("UpdateStatus")
		Set tmpLink = objXML.createNode(1, "DBContentItem", "")

		Set tmpLink2 = objXML.createNode(1, "SystemID", "")
		tmpLink2.text = SubstanceID
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "PropID", "")
		tmpLink2.text = NOMPROP
		tmpLink.appendChild(tmpLink2)
		Set tmpLink2 = objXML.createNode(1, "UpdateStatus", "")
		tmpLink2.text = UpdateStatus
		tmpLink.appendChild(tmpLink2)

		tmp.appendChild(tmpLink)
		XMLDBContentItems = XMLDBContentItems + 1
		RSN.MoveNext
	Loop
end function