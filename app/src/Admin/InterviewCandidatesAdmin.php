<?php

namespace SSTechInterview\Admin;

use SilverStripe\Admin\ModelAdmin;
use SSTechInterview\Model\InterviewCandidate;

class InterviewCandidatesAdmin extends ModelAdmin
{
    private static $url_segment = 'interview-candidates';

    private static $menu_title = 'Interview Candidates';

    private static $menu_icon_class = 'font-icon-checklist';

    private static $managed_models = [
        InterviewCandidate::class,
    ];
}
