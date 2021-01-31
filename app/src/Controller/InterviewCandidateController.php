<?php

namespace SSTechInterview\Controller;

use PageController;
use SilverStripe\Forms\FieldList;
use SilverStripe\Forms\FileField;
use SilverStripe\Forms\Form;
use SilverStripe\Forms\FormAction;
use SilverStripe\Forms\RequiredFields;
use SilverStripe\Forms\TextareaField;
use SilverStripe\Forms\TextField;
use SilverStripe\ORM\ValidationResult;
use SSTechInterview\Model\InterviewCandidate;

class InterviewCandidateController extends PageController
{
    private static $allowed_actions = [
        'CandidateSubmissionForm',
    ];

    public function CandidateSubmissionForm(): Form
    {
        return Form::create(
            $this,
            'CandidateSubmissionForm',
            FieldList::create(
                TextField::create('Name','Name'),
                TextareaField::create('CoverLetter','Please tell us why you are suitable for the role'),
                FileField::create('CV', 'Attach your CV here')
            ),
            FieldList::create(
                FormAction::create('doCandidateSubmit','Submit')
            ),
            RequiredFields::create('Name', 'CoverLetter', 'CV')
        );
    }

    public function doCandidateSubmit(array $data, Form $form)
    {
        if (strlen($data['CoverLetter']) < 20) {
            $form->sessionFieldError('Your cover letter should be at least 20 words', 'CoverLetter');
            return $this->redirectBack();
        }

        $candidate = InterviewCandidate::create();
        $form->saveInto($candidate);
        $candidate->write();

        $form->sessionMessage('Submission successful, thanks!', ValidationResult::TYPE_GOOD);

        return $this->redirectBack();
    }

}
