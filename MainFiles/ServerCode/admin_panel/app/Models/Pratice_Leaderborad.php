<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pratice_Leaderborad extends Model
{
    use HasFactory;

    protected $table = 'tbl_pratice_leaderboard';
    protected $guarded = array();

    public function users()
    {
        return $this->belongsTo(Users::class, 'user_id');
    }

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'level_id' => 'integer',
        'question_level_master_id' => 'integer',
        'category_id' => 'integer',
        'total_questions' => 'string',
        'questions_attended' => 'string',
        'correct_answers' => 'string',
        'score' => 'float',
        'is_unlock' => 'integer',
        'status' => 'integer',
    ];
}
