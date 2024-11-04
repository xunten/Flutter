<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Daily_Quiz_Question extends Model
{
    use HasFactory;

    protected $table = 'tbl_daily_quiz_question';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'question' => 'string',
        'question_type' => 'integer',
        'option_a' => 'string',
        'option_b' => 'string',
        'option_c' => 'string',
        'option_d' => 'string',
        'answer' => 'string',
        'image' => 'string',
        'note' => 'string',
    ];
}
