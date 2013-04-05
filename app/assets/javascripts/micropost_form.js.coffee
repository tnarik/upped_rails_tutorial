maxL=140

(exports ? this).taLimit = (taObj) ->
  if taObj.value.length == maxL then false else true

(exports ? this).taCount = (taObj, Cnt) ->
  objCnt = createObject (Cnt)
  objVal = taObj.value
  objVal = objVal.substring(0, maxL) if (objVal.length > maxL)

  if objCnt
    if navigator.appName == "Netscape"
      objCnt.textContent = maxL - objVal.length
    else objCnt.innerText = maxL - objVal.length
  true

createObject = (objId) ->
  if document.getElementById 
    document.getElementById(objId);
  else if document.layers
    "document." + objId
  else if document.all 
    "document.all." + objId
  else "document." + objId