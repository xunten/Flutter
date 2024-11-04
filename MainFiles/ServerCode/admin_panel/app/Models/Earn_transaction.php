<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Earn_transaction extends Model
{
    use HasFactory;

    protected $table = 'tbl_earn_transaction';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'contest_id' => 'integer',
        'type' => 'integer',
        'point' => 'string',
    ];
}
