import { Injectable, NotFoundException, Dependencies } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';

import { EmergencyBranch } from './branch.entity';

@Injectable()
@Dependencies(getRepositoryToken(EmergencyBranch))
export class BranchesService {
  constructor(branchesRepository) {
    this.branchesRepository = branchesRepository;
  }

  async findAll(query = {}) {
    if (query.type) {
      return this.branchesRepository.find({ where: { type: query.type } });
    }
    return this.branchesRepository.find();
  }

  async findOne(id) {
    const branch = await this.branchesRepository.findOne({ where: { id } });
    if (!branch) {
      throw new NotFoundException('Branch not found.');
    }
    return branch;
  }

  async create(payload) {
    const branch = this.branchesRepository.create({
      ...payload,
      id: payload.id ?? randomUUID(),
    });
    return this.branchesRepository.save(branch);
  }

  async update(id, payload) {
    const branch = await this.branchesRepository.preload({ id, ...payload });
    if (!branch) {
      throw new NotFoundException('Branch not found.');
    }
    return this.branchesRepository.save(branch);
  }

  async remove(id) {
    const branch = await this.findOne(id);
    await this.branchesRepository.remove(branch);
    return { deleted: true };
  }
}
