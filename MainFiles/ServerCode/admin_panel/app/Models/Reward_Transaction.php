<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reward_Transaction extends Model
{
    use HasFactory;

    protected $table = 'tbl_reward_transaction';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'reward_points' => 'string',
        'type' => 'integer',
    ];
}
