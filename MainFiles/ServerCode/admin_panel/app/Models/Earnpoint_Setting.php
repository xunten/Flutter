<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Earnpoint_Setting extends Model
{
    use HasFactory;

    protected $table = 'tbl_earnpoint_setting';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'key' => 'string',
        'value' => 'string',
        'type' => 'integer',
    ];
}
