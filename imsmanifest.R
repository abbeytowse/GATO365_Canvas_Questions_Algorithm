setwd("C:/Users/towse/R/canvas_quiz/pieces_of_code/squirrel quiz/Uploaded Media")
image_string_chunk = ''
ident = 1
image_name = 'mySquirrelImage.jpg'
image_string_chunk = paste(image_string_chunk, '<resource identifier="',ident,'" type="webcontent" href="Uploaded Media/',image_name,'">
      <file href="Uploaded Media/',image_name,'"/>
    </resource>')

imsmanifest_string = paste('<?xml version="1.0" encoding="UTF-8"?>
<manifest identifier="g0b02f0a3d20ecf118ce69553fef2d614" xmlns="http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1" xmlns:lom="http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource" xmlns:imsmd="http://www.imsglobal.org/xsd/imsmd_v1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1 http://www.imsglobal.org/xsd/imscp_v1p1.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lomresource_v1p0.xsd http://www.imsglobal.org/xsd/imsmd_v1p2 http://www.imsglobal.org/xsd/imsmd_v1p2p2.xsd">
  <metadata>
    <schema>IMS Content</schema>
    <schemaversion>1.1.3</schemaversion>
    <imsmd:lom>
      <imsmd:general>
        <imsmd:title>
          <imsmd:string>QTI Quiz Export for course "testing quizes"</imsmd:string>
        </imsmd:title>
      </imsmd:general>
      <imsmd:lifeCycle>
        <imsmd:contribute>
          <imsmd:date>
            <imsmd:dateTime>2021-07-09</imsmd:dateTime>
          </imsmd:date>
        </imsmd:contribute>
      </imsmd:lifeCycle>
      <imsmd:rights>
        <imsmd:copyrightAndOtherRestrictions>
          <imsmd:value>yes</imsmd:value>
        </imsmd:copyrightAndOtherRestrictions>
        <imsmd:description>
          <imsmd:string>Private (Copyrighted) - http://en.wikipedia.org/wiki/Copyright</imsmd:string>
        </imsmd:description>
      </imsmd:rights>
    </imsmd:lom>
  </metadata>
  <organizations/>
  <resources>
    <resource identifier="g123377d8a951f582fd306bc3750e13da" type="imsqti_xmlv1p2">
      <file href="g123377d8a951f582fd306bc3750e13da/g123377d8a951f582fd306bc3750e13da.xml"/>
      <dependency identifierref="g0a74eb3bc0da3b9cdc89000d2ebbc29f"/>
    </resource>
    <resource identifier="g0a74eb3bc0da3b9cdc89000d2ebbc29f" type="associatedcontent/imscc_xmlv1p1/learning-application-resource" href="g123377d8a951f582fd306bc3750e13da/assessment_meta.xml">
      <file href="g123377d8a951f582fd306bc3750e13da/assessment_meta.xml"/>',image_string_chunk,'
    </resource>
  </resources>
</manifest>
')

setwd("C:/Users/towse/R/canvas_quiz/pieces_of_code/squirrel quiz")
#write xml file 
write(imsmanifest_string, file = 'imsmanifest.xml')