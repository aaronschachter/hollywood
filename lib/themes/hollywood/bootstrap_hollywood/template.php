<?php

/**
 * @file
 * template.php
 */

/**
 * Implements hook_preprocess_node().
 */
function bootstrap_hollywood_preprocess_page(&$vars) {
  //dsm($vars);
}


/**
 * Implements hook_preprocess_node().
 */
function bootstrap_hollywood_preprocess_node(&$vars) {
  if (isset($vars['field_post_type'])) {
    $tid = $vars['field_post_type'][LANGUAGE_NONE][0]['tid'];
    $term = taxonomy_term_load($tid);
    $vars['classes_array'][] = lcfirst($term->name);
  }
}
