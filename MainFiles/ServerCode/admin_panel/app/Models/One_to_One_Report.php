<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class One_to_One_Report extends Model
{
    use HasFactory;

    protected $table = 'tbl_one_to_one_save_report';
    protected $guarded = array();

}
