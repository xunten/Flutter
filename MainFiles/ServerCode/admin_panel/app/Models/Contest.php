<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Contest extends Model
{
    use HasFactory;

    protected $table = 'tbl_contest';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'name' => 'string',
        'type' => 'integer',
        'level_id' => 'integer',
        'image' => 'string',
        'price' => 'string',
        'no_of_user' => 'integer',
        'no_of_user_prize' => 'integer',
        'no_of_rank' => 'integer',
        'total_prize' => 'integer',
        'prize_json' => 'string',
        'status' => 'integer',
    ];
}
