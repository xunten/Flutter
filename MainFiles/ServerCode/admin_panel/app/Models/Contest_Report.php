<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Contest_Report extends Model
{
    use HasFactory;

    protected $table = 'tbl_contest_save_report';
    protected $guarded = array();

    public function users()
    {
        return $this->belongsTo(Users::class, 'user_id');
    }

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'contest_id' => 'integer',
        'total_questions' => 'string',
        'questions_attended	' => 'string',
        'correct_answers' => 'string',
        'score' => 'float',
        'question_json' => 'string',
        'status' => 'integer',
    ];
}
