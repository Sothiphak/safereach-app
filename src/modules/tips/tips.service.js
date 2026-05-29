import { Injectable, NotFoundException, Dependencies } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Tip } from './tip.entity';

@Injectable()
@Dependencies(getRepositoryToken(Tip))
export class TipsService {
  constructor(tipsRepository) {
    this.tipsRepository = tipsRepository;
  }

  async findAll() {
    return this.tipsRepository.find();
  }

  async findOne(id) {
    const tip = await this.tipsRepository.findOne({ where: { id } });
    if (!tip) {
      throw new NotFoundException('First-aid tip not found.');
    }
    return tip;
  }

  async create(payload) {
    const tip = this.tipsRepository.create(payload);
    return this.tipsRepository.save(tip);
  }
}
