<?php print $messages; ?>
<?php if (!empty($tabs)): ?>
  <?php print render($tabs); ?>
<?php endif; ?>

<div id="wrapper">

  <div id="sidebar-wrapper">
    <ul class="sidebar-nav">
      <li class="sidebar-brand">
        <a href="<?php print $front_page; ?>" title="<?php print t('Home'); ?>">
          Aaron Schachter
        </a>
      </li>
      <li>
        <?php print l('Code', 'code'); ?>
      </li>
      <li>
        <a href="#" class="dropdown-nav">Art</a>
        <ul class="dropdown-nav-menu">
          <li>
            <?php print l('Drawings', 'drawings'); ?>
          </li>
          <li>
            <?php print l('Comics', 'comics'); ?>
          </li>
          <li>
            <?php print l('Paintings', 'paintings'); ?>
          </li>
        </ul>
      </li>
      <li>
        <?php print l('Writing', 'haiku'); ?>
      </li>
      <li>
        <?php print l('Video', 'video'); ?>
      </li>
      <li>
        <ul class="secondary-nav">
          <li>
            <?php print l('About', 'about'); ?>
          </li>
        </ul>
      </li>
    </ul>
  </div>
  <!-- /#sidebar-wrapper -->

  <!-- Page Content -->
  <div id="page-content-wrapper">
    <!-- Mobile navigation -->
    <div class="navbar container visible-xs-block" id="menu-toggle">
      <div class="navbar-header">
        <a class="name navbar-brand" href="<?php print $front_page; ?>" title="<?php print t('Home'); ?>"><?php print $site_name; ?></a>
        <!-- .btn-navbar is used as the toggle for collapsed navbar content -->
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
      </div>
    </div>
    <div class="container-fluid">
      <?php if (!empty($title)): ?>
        <h1 class="page-header"><?php print $title; ?></h1>
      <?php endif; ?>
      <div class="row">
        <div class="col-lg-12">
          <?php print render($page['content']); ?>
        </div>
      </div>
    </div>
  </div>
  <!-- /#page-content-wrapper -->
<!--   <footer class="footer container">
    <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12">
          &copy; <?php echo date("Y") ?> Aaron Schachter.
        </div>
      </div>
    </div>
  </footer> -->
</div>

<!-- Menu Toggle Script -->
<script>
jQuery(".dropdown-nav-menu").hide();
jQuery("#menu-toggle").click(function(e) {
  e.preventDefault();
  jQuery("#wrapper").toggleClass("toggled");
});
jQuery(".dropdown-nav").click(function(e) {
  jQuery(".dropdown-nav-menu").toggle();
});
jQuery("img").addClass("img-responsive");
</script>
