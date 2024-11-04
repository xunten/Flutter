<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Level extends Model
{
    use HasFactory;

    protected $table = 'tbl_level';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'name' => 'string',
        'level_order' => 'integer',
        'score' => 'integer',
        'win_question_count' => 'integer',
        'total_question' => 'integer',
        'status' => 'integer',
    ];
}
