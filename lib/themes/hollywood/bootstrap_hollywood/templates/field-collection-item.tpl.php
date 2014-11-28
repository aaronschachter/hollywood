<div>
  <h3><?php print $content['field_heading'][0]['#markup']; ?></h3>
  <?php if (!empty($content['field_copy'])): ?>
    <div>
      <?php print $content['field_copy'][0]['#markup']; ?>
    </div>
  <?php endif; ?>
</div>
