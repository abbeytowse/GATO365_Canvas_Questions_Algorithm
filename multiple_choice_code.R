library(tidyverse)
library(rlist)
library(readxl)

setwd("C:/Users/towse/R/canvas_quiz/pieces_of_code")

question_bank = read_xlsx('my_mc_only_fake_quiz.xlsx')

title = 'my 10 mc questions xml chunk'
time_limit = 'unlimited'
max_attempts = 'unlimited'

beginning_xml_chunk = paste('<?xml version="1.0" encoding="UTF-8"?>
<questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
  <assessment ident="gacc8cbc8c785376e85ccd059145646cb" title="', title,'">
    <qtimetadata>
      <qtimetadatafield>
        <fieldlabel>qmd_timelimit</fieldlabel>
        <fieldentry>', time_limit, '</fieldentry>
      </qtimetadatafield>
      <qtimetadatafield>
        <fieldlabel>cc_maxattempts</fieldlabel>
        <fieldentry>', max_attempts, '</fieldentry>
      </qtimetadatafield>
    </qtimetadata>
    <section ident="root_section">')


mc_xml_chunk = ''
for (i in 1:nrow(question_bank)) {
  question_options = question_bank$question_options[i] %>% 
    str_replace_all(';', ',')
  ans_choices_list = as.list(str_split(question_options, ',')[[1]])
  
ident = toString(i)
num_ans_choices = length(ans_choices_list)
points = question_bank$points[i]
question = question_bank$question_stem[i]
corr_ans = question_bank$answer[i]
corr_ans_index = match(tolower(corr_ans), tolower(ans_choices_list))
corr_ans_resp = paste('response', corr_ans_index[1]) %>% 
  str_remove_all(' ')
corr_ans_resp_code = paste(corr_ans_index, corr_ans_index, corr_ans_index, corr_ans_index) %>% 
  str_remove_all(' ')

ans_choices_codes = ''
ans_choices_codes_list = list()
for (i in 1:num_ans_choices){
  num = toString(i)
  four_digit_code = paste(num, num, num, num) %>% 
    str_remove_all(' ')
  ans_choices_codes = paste(ans_choices_codes, four_digit_code, ',')
  ans_choices_codes_list = list.append(ans_choices_codes_list, four_digit_code)
}
ans_choices_codes = str_remove_all(ans_choices_codes, ' ')

repeat_mc_code = ''
for (i in 1:num_ans_choices) {
  resp_val = paste('response', i) %>% 
    str_remove_all(' ')
  repeat_mc_code = paste(repeat_mc_code, '<response_lid ident="',resp_val, '" rcardinality="Single">
            <render_choice>
              <response_label ident="',ans_choices_codes_list[i],'">
                <material>
                  <mattext texttype="text/plain">',ans_choices_list[i],'</mattext>
                </material>
              </response_label>
            </render_choice>
          </response_lid>')
}

mc_xml_chunk = paste(mc_xml_chunk,'<item ident="', ident,'" title="Question">
        <itemmetadata>
          <qtimetadata>
            <qtimetadatafield>
              <fieldlabel>question_type</fieldlabel>
              <fieldentry>multiple_choice_question</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>points_possible</fieldlabel>
              <fieldentry>',points,'</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>original_answer_ids</fieldlabel>
              <fieldentry>', ans_choices_codes, '</fieldentry>
            </qtimetadatafield>
            <qtimetadatafield>
              <fieldlabel>assessment_question_identifierref</fieldlabel>
              <fieldentry>g2e96198227a3229fb48608ba1634367a</fieldentry>
            </qtimetadatafield>
          </qtimetadata>
        </itemmetadata>
        <presentation>
          <material>
            <mattext texttype="text/html">&lt;div&gt;&lt;p&gt;', question, '&lt;/p&gt;&lt;/div&gt;</mattext>
          </material>', repeat_mc_code,'</presentation>
        <resprocessing>
          <outcomes>
            <decvar maxvalue="100" minvalue="0" varname="SCORE" vartype="Decimal"/>
          </outcomes>
          <respcondition continue="No">
            <conditionvar>
              <varequal respident="',corr_ans_resp,'">',corr_ans_resp_code,'</varequal>
            </conditionvar>
            <setvar action="Set" varname="SCORE">100</setvar>
          </respcondition>
        </resprocessing>
      </item>')
}

ending_xml_chunk = '    </section>
  </assessment>
</questestinterop>
'

xml_chunk = paste(beginning_xml_chunk, mc_xml_chunk, ending_xml_chunk) 

write(xml_chunk, file = 'my_10_question_mc_xml_chunk.xml')