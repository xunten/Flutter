<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Classification extends Model
{
    use HasFactory;

    protected $table = 'tbl_classification';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'level_name' => 'string',
        'level_order' => 'integer',
    ];
}
