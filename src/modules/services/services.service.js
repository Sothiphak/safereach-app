import { Injectable, NotFoundException, Dependencies } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';

import { EmergencyService } from './service.entity';

@Injectable()
@Dependencies(getRepositoryToken(EmergencyService))
export class ServicesService {
  constructor(servicesRepository) {
    this.servicesRepository = servicesRepository;
  }

  async findAll(query = {}) {
    const qb = this.servicesRepository.createQueryBuilder('service');

    if (query.type) {
      qb.andWhere('service.type = :type', { type: query.type });
    }
    if (query.openNow !== undefined) {
      qb.andWhere('service.openNow = :openNow', { openNow: query.openNow });
    }
    if (query.minRating !== undefined) {
      qb.andWhere('service.rating >= :minRating', {
        minRating: query.minRating,
      });
    }
    if (query.maxDistance !== undefined) {
      qb.andWhere('service.distanceKm <= :maxDistance', {
        maxDistance: query.maxDistance,
      });
    }
    if (query.search) {
      const search = `%${query.search.toLowerCase()}%`;
      qb.andWhere(
        '(LOWER(service.name) LIKE :search OR LOWER(service.address) LIKE :search)',
        { search },
      );
    }

    qb.orderBy('service.distanceKm', 'ASC');
    return qb.getMany();
  }

  async findOne(id) {
    const service = await this.servicesRepository.findOne({ where: { id } });
    if (!service) {
      throw new NotFoundException('Service not found.');
    }
    return service;
  }

  async create(payload) {
    const service = this.servicesRepository.create({
      ...payload,
      id: payload.id ?? randomUUID(),
      reviewCount: payload.reviewCount ?? 0,
      rating: payload.rating ?? 0,
    });
    return this.servicesRepository.save(service);
  }

  async update(id, payload) {
    const service = await this.servicesRepository.preload({
      id,
      ...payload,
    });
    if (!service) {
      throw new NotFoundException('Service not found.');
    }
    return this.servicesRepository.save(service);
  }

  async remove(id) {
    const service = await this.findOne(id);
    await this.servicesRepository.remove(service);
    return { deleted: true };
  }
}
