<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Earn_point extends Model
{
    use HasFactory;

    protected $table = 'tbl_earn_point';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'key' => 'string',
        'value' => 'string',
        'type' => 'integer',
        'point_type' => 'integer',
    ];
}
