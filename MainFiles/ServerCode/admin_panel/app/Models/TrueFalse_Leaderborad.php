<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TrueFalse_Leaderborad extends Model
{
    use HasFactory;

    protected $table = 'tbl_true_false_leaderboard';
    protected $guarded = array();

    public function users()
    {
        return $this->belongsTo(Users::class, 'user_id');
    }

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'category_id' => 'integer',
        'total_questions' => 'string',
        'questions_attended' => 'string',
        'correct_answers' => 'string',
        'score' => 'float',
        'is_win_point' => 'integer',
        'status' => 'integer',
    ];
}
