extends Node3D
class_name CircleGenerator

##
## The number of points to calculate.
##
var m_nItems : int

##
## An array to hold the generated points.
##
var m_aCoordinates = []

##
## The number of degrees around the circle to distribute the points.
##
var m_nTotalSpan = 360

##
## The scaling factor to make the generated circle larger or smaller.
##
var m_nScale : float = 3

func _ready():
	pass

func getCoordinates():
	return m_aCoordinates

func getScale():
	return m_nScale
	
func setItems(a):
	m_nItems = a

func setTotalSpan(a):
	m_nTotalSpan = a

func setScale(a : float):
	m_nScale = a
	
func generateXY():
	if m_nItems != 0:
		var nIncrement = float(m_nTotalSpan) / float(m_nItems)
		var nAngle = 0

		m_aCoordinates.clear()
		while nAngle < float(m_nTotalSpan):
			var x = cos(deg_to_rad(nAngle))
			var y = sin(deg_to_rad(nAngle))

			m_aCoordinates.append(Vector3(x * m_nScale,y * m_nScale,0))
			nAngle += nIncrement

func generateXZ():
	if m_nItems != 0:
		var nIncrement = float(m_nTotalSpan) / float(m_nItems)
		var nAngle = 0

		m_aCoordinates.clear()
		while nAngle < float(m_nTotalSpan):
			var x = cos(deg_to_rad(nAngle))
			var z = sin(deg_to_rad(nAngle))

			m_aCoordinates.append(Vector3(x * m_nScale,0,z * m_nScale))
			nAngle += nIncrement
