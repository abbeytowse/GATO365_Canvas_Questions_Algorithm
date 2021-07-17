library(tidyverse)
library(readxl)

setwd("C:/Users/towse/R/canvas_quiz/pieces_of_code")
question_bank = read_xlsx('mc_text_box_numeric_open_ended_matching_file_upload_select_all.xlsx')
point_total = toString(sum(question_bank$points, na.rm=TRUE))

#USER INPUT
title = 'testing meta data'    #needs to match name in xml_canvas_questions.R
description = 'this is my meta data description'    #type description here if applicable 
shuffle_answers = 'true'    #'true' to shuffle, 'false' to not shuffle
lock_at = 'true'    #'true' if you want the quiz to lock, 'false' if you don't want the quiz to lock
#HOW DO WE DIFFERENTIATE AM AND PM?????
lock_time = '2021-07-15TO8:00:00'    #if 'true' YYYY-MM-DDTOHH:MM:SS, leave '' if 'false'
unlock_time = '2021-07-15TO5:00:00'    #if 'true' YYYY-MM-DDTOHH:MM:SS, leave '' if 'false'
due_date = '2021-07-15TO7:30:00'    #if 'true' YYYY-MM-DDTOHH:MM:SS, leave '' if 'false'
scoring_policy = 'keep_average'    #'keep_highest', 'keep_latest', or 'keep_average'
hide_results = 'always'    #'always' to hide results, 'until_after_last_attempt' 

if (lock_time == '') {
  lock_at = ''
} else {
  lock_at = paste('<lock_at>',lock_time,'</lock_at>')
}
if (unlock_time == '') {
  unlock_at = ''
} else {
  unlock_at = paste('<unlock_at>',unlock_time,'</unlock_at>')
}
if (due_date == '') {
  due_at = ''
} else {
  due_at = paste('<due_at>',due_date,'</due_at>')
}

meta_data = paste('<?xml version="1.0" encoding="UTF-8"?>
<quiz identifier="g2a442f5b76dbb5e018f5d2713aaa6eb3" xmlns="http://canvas.instructure.com/xsd/cccv1p0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://canvas.instructure.com/xsd/cccv1p0 https://canvas.instructure.com/xsd/cccv1p0.xsd">
  <title>',title,'</title>
  <description>',description,'</description>
  ',lock_at, unlock_time, due_at,'
  <shuffle_answers>',shuffle_answers,'</shuffle_answers>
  <scoring_policy>',scoring_policy,'</scoring_policy>
  <hide_results>',hide_results,'</hide_results>
  <quiz_type>assignment</quiz_type>
  <points_possible>',point_total,'</points_possible>
  <require_lockdown_browser>false</require_lockdown_browser>
  <require_lockdown_browser_for_results>false</require_lockdown_browser_for_results>
  <require_lockdown_browser_monitor>false</require_lockdown_browser_monitor>
  <lockdown_browser_monitor_data/>
  <show_correct_answers>true</show_correct_answers>
  <anonymous_submissions>false</anonymous_submissions>
  <could_be_locked>false</could_be_locked>
  <disable_timer_autosubmission>false</disable_timer_autosubmission>
  <allowed_attempts>1</allowed_attempts>
  <one_question_at_a_time>false</one_question_at_a_time>
  <cant_go_back>false</cant_go_back>
  <available>false</available>
  <one_time_results>false</one_time_results>
  <show_correct_answers_last_attempt>false</show_correct_answers_last_attempt>
  <only_visible_to_overrides>false</only_visible_to_overrides>
  <module_locked>false</module_locked>
  <assignment identifier="ge4a322dfee00b2af877f1a2ea3ef0326">
    <title>2 select alls </title>
    <due_at/>
    <lock_at/>
    <unlock_at/>
    <module_locked>false</module_locked>
    <workflow_state>unpublished</workflow_state>
    <assignment_overrides>
    </assignment_overrides>
    <quiz_identifierref>g2a442f5b76dbb5e018f5d2713aaa6eb3</quiz_identifierref>
    <allowed_extensions></allowed_extensions>
    <has_group_category>false</has_group_category>
    <points_possible>3.0</points_possible>
    <grading_type>points</grading_type>
    <all_day>false</all_day>
    <submission_types>online_quiz</submission_types>
    <position>37</position>
    <turnitin_enabled>false</turnitin_enabled>
    <vericite_enabled>false</vericite_enabled>
    <peer_review_count>0</peer_review_count>
    <peer_reviews>false</peer_reviews>
    <automatic_peer_reviews>false</automatic_peer_reviews>
    <anonymous_peer_reviews>false</anonymous_peer_reviews>
    <grade_group_students_individually>false</grade_group_students_individually>
    <freeze_on_copy>false</freeze_on_copy>
    <omit_from_final_grade>false</omit_from_final_grade>
    <intra_group_peer_reviews>false</intra_group_peer_reviews>
    <only_visible_to_overrides>false</only_visible_to_overrides>
    <post_to_sis>false</post_to_sis>
    <moderated_grading>false</moderated_grading>
    <grader_count>0</grader_count>
    <grader_comments_visible_to_graders>true</grader_comments_visible_to_graders>
    <anonymous_grading>false</anonymous_grading>
    <graders_anonymous_to_graders>false</graders_anonymous_to_graders>
    <grader_names_visible_to_final_grader>true</grader_names_visible_to_final_grader>
    <anonymous_instructor_annotations>false</anonymous_instructor_annotations>
    <post_policy>
      <post_manually>false</post_manually>
    </post_policy>
  </assignment>
  <assignment_group_identifierref>g8c0ff6d4d6c119df6a3ac6438d26bfc6</assignment_group_identifierref>
  <assignment_overrides>
  </assignment_overrides>
</quiz>')

setwd("C:/Users/towse/R/canvas_quiz/pieces_of_code")
write(meta_data, )