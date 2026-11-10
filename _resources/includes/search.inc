<?php /* Shared search form: submits queries to the dedicated /search.php results page. */ ?>
<ouc:editor wysiwyg="no"/>
<form action="/search.php" method="get" role="search" aria-label="Search the LTCC website">
    <label class="d-block">
        <span class="form-label d-block">Search the LTCC website</span>
        <input type="search" name="q" class="form-control form-control-lg" placeholder="What are you looking for?" required="required" />
    </label>
    <button type="submit" class="btn btn-primary mt-3">
        <span class="fa-sharp fa-solid fa-search me-2" aria-hidden="true"></span>Search
    </button>
</form>
